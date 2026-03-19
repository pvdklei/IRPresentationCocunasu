"""
Reproduce Figure 3 from "The Power of Noise" paper and test whether
document ordering affects the attention pattern.

Generates two pairs of images:
  1. Distracting docs (original order + shuffled order)
  2. Random docs (original order + shuffled order)

Usage:
    python attention.py [--output-dir images]

Requires macOS with Metal (MPS) or falls back to CPU.
"""

from __future__ import annotations

import os
import gc
import re
import random
import argparse
from typing import List

import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

import torch
from transformers import (
    AutoConfig, AutoTokenizer, AutoModelForCausalLM,
)

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
SEED = 10

MODELS = {
    "llama2": {"id": "meta-llama/Llama-2-7b-chat-hf", "max_length": 4096, "answer_prefix": "Answer:"},
    "phi2":   {"id": "microsoft/phi-2",                "max_length": 2048, "answer_prefix": "Answer:"},
    "falcon": {"id": "tiiuae/falcon-7b-instruct",      "max_length": 2048, "answer_prefix": "Answer:"},
    "mpt":    {"id": "mosaicml/mpt-7b-instruct",       "max_length": 2048, "answer_prefix": "### Response:"},
}
DEFAULT_MODEL = "llama2"

INSTRUCTION = (
    "You are given a question and you MUST respond by EXTRACTING the answer "
    "(max 5 tokens) from one of the provided documents. If none of the "
    "documents contain the answer, respond with NO-RES."
)

# The same example used in the paper (idx 3865 from numdoc13_gold_at12)
QUESTION = "who owned the millennium falcon before han solo"
CORRECT_ANSWER = "Lando Calrissian"

# Gold document (Document [20995349]) — always position 12 (last) in original
GOLD_DOC = (
    '(Title: Millennium Falcon) Han Solo won the Millennium Falcon from '
    "Lando Calrissian in the card game ' sabacc ' several years before the "
    'events of the film A New Hope . In Star Wars , Obi - Wan Kenobi '
    '( Alec Guinness ) and Luke Skywalker ( Mark Hamill ) charter the ship '
    'in the Mos Eisley Cantina to deliver them , C - 3PO ( Anthony Daniels ) , '
    'R2 - D2 ( Kenny Baker ) , and the stolen Death Star plans to Alderaan . '
    'When the Falcon is captured by the Death Star , the group conceal '
    'themselves in smuggling compartments built into the floor to avoid '
    'detection during a search of the ship . Solo later collects his fee for '
    'delivering them to the hidden Rebel base and departs under bitter '
    'circumstances , but returns to assist Luke in destroying the Death Star .'
)

# 12 distracting documents (same topic, no answer) — from the paper's example
DISTRACTING_DOCS = [
    '(Title: Millennium Falcon) make it out of Kessel in less than 20 parsecs. '
    "After integrating the memory module of Lando's damaged L3 droid into the "
    "ship's navigation, Solo is able to take a \"shortcut\" dangerously close "
    'to the black holes. Chewbacca indicates the real distance was closer to '
    '13 parsecs, but Han insisted, "Not if you round down." implying that the '
    'distance of "less than twelve parsecs" was embellished by Solo. The '
    '"Falcon" has been depicted many times in the franchise, and ownership has '
    'changed several times. Joss Whedon credits the "Millennium Falcon" as one '
    'of his two primary inspirations for his "Firefly"',

    '(Title: The Han Solo Trilogy) refuses to believe Han was not involved in '
    'the swindle, and punches his former friend in the jaw. Desperate for '
    'money, Han and Chewbacca take a spice smuggling run from Jabba the Hutt '
    "(who has inherited his aunt's criminal empire) through the Kessel Run. "
    'However, they are met mid-Run by an Imperial patrol, and are forced to '
    'abandon their cargo in deep space while the "Falcon" is searched and '
    'escorted to a nearby world. When they come back to look for the cargo, '
    'however, they discover it has disappeared. Han tries to explain what '
    'happened, but Jabba — in a',

    '(Title: Skywalker family) her son from the dark side. Han\'s surname Solo, '
    'was not his birth name, with Han being given his Solo surname by an '
    'imperial officer right before Han joined the imperial flight academy, '
    'which he would leave three years after. Han Solo\'s first film appearance '
    'however was in 1977\'s "Star Wars: A New Hope" where he is played by '
    'Harrison Ford. He and his Wookiee co-pilot and best friend, Chewbacca '
    'are initially hired to transport Luke Skywalker and Obi-wan Kenobi. Han '
    'and Chewbacca later become involved in the Rebel Alliance and are '
    'committed to its cause. Over the course of',

    '(Title: Steve Sansweet) professionally appraised for a total of more than '
    '$200,000." According to Sansweet, a man named Carl Edward Cunningham, '
    'whom Sansweet refers to as "a good and trusted friend," surrendered to '
    'police at the end of March 2017 but is currently out on bail pending '
    'additional hearings. Steve Sansweet Stephen J. Sansweet (born June 14, '
    '1945) is the chairman and president of Rancho Obi-Wan, a nonprofit museum '
    'that houses the world\'s largest collection of "Star Wars" memorabilia. '
    'Prior to his retirement in April 2011, he was Director of Content '
    'Management and head of Fan Relations at Lucasfilm Ltd. for 15 years,',

    '(Title: Han Solo) Jedi". In "The Courtship of Princess Leia" (1995), he '
    'resigns his commission to pursue Leia, whom he eventually marries. Solo '
    'and Leia have three children: twins Jaina and Jacen and son Anakin. Han '
    'Solo was the general in command of the New Republic task force assigned to '
    'track down Imperial Warlord Zsinj and his forces, in the 1999 novel '
    '"Solo Command". Chewbacca dies saving Anakin\'s life in "Vector Prime" '
    "(1999), sending Solo into a deep depression. In \"Star by Star\" (2001), "
    "Anakin dies as well, compounding Solo's despair. At the end of the "
    'series, however, Solo accepts the deaths of',

    '(Title: Millennium Falcon) "Falcon" for their own. Forced to escape in '
    'the "Falcon" from an ambush by parties to whom Solo is heavily in debt, '
    'Solo reluctantly agrees to help Rey and Finn return BB-8 to the '
    'Resistance. The "Falcon" appears again in "Star Wars: The Last Jedi", '
    'still on Ahch-To with Rey and Chewbacca. Later in the film, Chewbacca '
    'and Rey take the "Falcon" to the planet Crait, where the Resistance is '
    'under attack by the First Order. The "Falcon" loses its sensor dish for '
    'the third time on Crait, after it is shot off by a TIE fighter. After '
    'the battle,',

    '(Title: Han Solo) (1977), when he and his co-pilot Chewbacca accept a '
    'charter request to transport Luke Skywalker, Obi-Wan Kenobi, C-3PO, and '
    'R2-D2 from Tatooine to Alderaan on their ship, the "Millennium Falcon". '
    'Han owes crime lord Jabba the Hutt a great deal of money and has a price '
    'on his head. Bounty hunter Greedo tries to deliver Solo to Jabba, dead '
    'or alive, but after a failed attempt to extort the money as a bribe for '
    'letting him go, Han shoots first and kills Greedo. Han then prepares to '
    'leave Tatooine. He and his passengers are attacked by Imperial '
    'stormtroopers, but escape',

    '(Title: Galactic Civil War) from Vader that he was his father, but '
    'escaped to Lando and Leia aboard the "Millennium Falcon". In "Return of '
    'the Jedi", the Imperial and Alliance fleets clashed as the second Death '
    'Star finished construction. Solo, who had been rescued from Jabba the '
    'Hutt and Boba Fett, and Leia fought Imperials on the forest moon of '
    'Endor below the Death Star, with the help of native Ewoks. Meanwhile, '
    'Luke surrendered himself to Vader and the Emperor, Darth Sidious. The '
    'rebels on Endor blew up a shield generator, allowing the Alliance fleet '
    'to assault the Death Star. Meanwhile, Luke re-armed himself',

    '(Title: Solo family) spent time alone thinking about the role of the '
    'Force, and would get into arguments with his brother Jacen on the '
    'subject. However, his uncle Luke still sees Anakin as too young and '
    'reckless. Solo family The Solo family is a fictional family of characters '
    'in the "Star Wars" franchise, whose most key member is smuggler Han Solo, '
    'one of the central protagonists of the franchise starting in the original '
    'film trilogy which he is featured prominently throughout. Subsequent to '
    "these films' events, Han marries Princess Leia, hence connecting her "
    'family tree to his; their son Ben Solo is introduced',

    '(Title: Star Wars Trilogy) Luke\'s absent father, Anakin Skywalker, who '
    "was Obi-Wan's Jedi apprentice until being murdered by Vader. He tells "
    'Luke he must also become a Jedi. After discovering his family\'s '
    'homestead has been destroyed by the Empire, they hire the smuggler Han '
    'Solo, his Wookiee Chewbacca and their space freighter, the "Millennium '
    'Falcon". They discover that Leia\'s homeworld of Alderaan has been '
    'destroyed, and are soon captured by the planet-destroying Death Star. '
    "While Obi-Wan disables its tractor beam, Luke and Han rescue the captive "
    'Princess Leia. Finally, they deliver the Death Star plans to the Rebel '
    'Alliance with the hope of exploiting',

    '(Title: Chewbacca) television, books, comics, and video games. '
    "Chewbacca, a 200-year-old Wookiee, becomes a young Han Solo's companion "
    'after they both escape Imperial captivity on Minban. After a series of '
    'adventures on Vandor and Kessel, Chewbacca embarks on the smuggling '
    "trade, serving as Han's co-pilot on the \"Millennium Falcon\" for the "
    "rest of Han's life. Standing at eight feet tall, Chewbacca is covered "
    'with long hair and wears only a bandolier. His weapon of choice is the '
    'Wookiee bowcaster (a crossbow-shaped directed-energy weapon). Chewbacca '
    'was named one of the "greatest sidekicks" in film history by '
    '"Entertainment Weekly". In France, in "Episode IV",',

    '(Title: Han Solo) old life as a smuggler. Before the events of the film, '
    'he and Chewbacca had lost the "Millennium Falcon" to thieves, but they '
    'reclaim the ship after it takes off from the planet Jakku, piloted by '
    'the scavenger Rey and the renegade stormtrooper Finn. As mercenaries '
    'close in on them, Han takes the "Falcon" into light speed, and they get '
    'away. When Han learns that Rey is looking for Luke, who disappeared '
    'years before, he takes them to Maz Kanata, who can deliver the droid '
    'BB-8 to the Resistance against the tyrannical First Order, the new '
    'version of the old',
]

# 12 random documents (unrelated topics) — from the paper's example
RANDOM_DOCS = [
    '(Title: Ethnobotany) in traditional Iroquois cultures is rooted in a '
    'strong and ancient cosmological belief system. Their work provides '
    'perceptions and conceptions of illness and imbalances which can manifest '
    'in physical forms from benign maladies to serious diseases. It also '
    'includes a large compilation of Herrick\'s field work from numerous '
    'Iroquois authorities of over 450 names, uses, and preparations of plants '
    'for various ailments. Traditional Iroquois practitioners had (and have) a '
    'sophisticated perspective on the plant world that contrast strikingly with '
    'that of modern medical science. Researcher Cassandra Quave at Emory '
    'University has used ethnobotany to address the problems that arise from',

    '(Title: RAF Cranwell) Centre (OASC), where all applicants to the RAF as '
    'Officers or non-commissioned aircrew, are put through a 4-day rigorous '
    'selection process. The OASC is currently commanded by Group Captain Tom '
    'McWilliams. The selection process features aptitude testing, medical '
    'examinations, interviews, plus a number of challenging individual plus '
    'team planning and initiative exercises. It is also home to the '
    'Inspectorate of Recruiting (IofR) – the division of the RAF responsible '
    'for providing recruiting and outreach services via the network of Armed '
    'Forces Careers Offices (AFCOs) around the UK. Around the 1970s the RAF '
    'introduced the Direct Entry Scheme, in which a',

    '(Title: LafargeHolcim Foundation for Sustainable Construction) of '
    'material and energy, should be an integral part of the design philosophy. '
    'Projects must be economically feasible and able to secure financing – '
    'whether from public, commercial, or concessional sources – while having a '
    'positive impact on society and the environment. Avoiding the wasteful '
    'consumption of material resources, an economy of means in construction is '
    'to be promoted. Projects must convey a high standard of architectural '
    'quality as a prevalent form of cultural expression. With space, form and '
    'aesthetic impact of utmost significance, the material manifestation of '
    'the design must make a positive and lasting contribution to the physical,',

    '(Title: Ouyang Yuqian) largest Chinese film studios, and helped the '
    'studio secure a crucial bank loan using his own family resources. He made '
    'three films with Mingxing: "Qingming Festival" (清明时节), "Xiao Lingzi" '
    '(小玲子), and "Red Haitang" (海棠红). Ouyang Yuqian joined Lianhua Film '
    'Company in 1937. While he was shooting the film "So Busy" (如此繁华), the '
    'Empire of Japan launched a full-scale invasion of Shanghai, which '
    'destroyed most of the city\'s film studios. After Japan occupied the '
    'Chinese sections of Shanghai, Ouyang made several anti-Japanese plays in '
    'the Shanghai International Settlement, before fleeing to British Hong '
    'Kong, where he wrote the screenplay for the',

    '(Title: Mei Sheng) Mei Sheng Mei Sheng (, "Beautiful Life" or "Born in '
    'the USA"; born August 19, 2003) is a male giant panda born at the San '
    'Diego Zoo. He is the second panda to be born at the zoo and is the first '
    'offspring of Bai Yun and Gao Gao. He is the half brother of Hua Mei and '
    'the brother of Su Lin, Zhen Zhen, Yun Zi, and Xiao Liwu. Mei Sheng was '
    'sent to China on November 5, 2007. He was reported to have arrived safely '
    'at the Wolong National Nature Reserve on November 8, 2007. After the 2008',

    '(Title: Centenari) the M1s was classified as finishing, in last place '
    'overall; the other M1 did not start the race, and the Mac3 completed too '
    'few laps to be classified. Anderstorp once more saw only one M1 finish, '
    "in last place overall; the Mac3's gearbox failed after 31 laps, and the "
    "other M1's differential failed after a single lap. Nürburgring saw a "
    'small improvement; the Mac3 and one M1 both finished, in twelfth and '
    'thirteenth overall; however, these were the bottom positions in the CN '
    'class. At the penultimate round at Le Mans, the Mac3 finished tenth '
    'overall and second in class,',

    '(Title: George Mouat Keith) the lands by Keith\'s father, John Mowat '
    'Keith, as a result of debts to John Scott. Keith lost the case on the '
    "grounds that Mr Nicolson was effectively a 'sitting tenant'. In 1819 he "
    'published "A Voyage to South America and the Cape of Good Hope in His '
    'Majesty\'s Brig Protector". Among its subscribers were including HRH The '
    'Duke of Clarence, HRH The Duke of Kent, The Right Honourable Lord '
    'Viscount Keith (no known relation), HRH The Duke of Sussex and assorted '
    'Lords, Ladies, MPs. The book was dedicated to the Right Honourable Lord '
    'Viscount Melville of the Admiralty, who',

    '(Title: Silviculture) a low rate of survival. Black spruce responded '
    'similarly. After two growing seasons, long day plants of all 4 species in '
    'Florida were well balanced, with good development of both roots and '
    'shoots, equaling or exceeding the minimum standards for 2+1 and 2+2 '
    'outplanting stock of Lake States species. Their survival when lifted in '
    'February and outplanted in Wisconsin equalled that of 2+2 '
    'Wisconsin-grown transplants. Artificial extension of the photoperiod in '
    'the northern Lake States greatly increased height increment of white and '
    'black spruces in the second growing season. Optimum conditions for '
    'seedling growth have been determined for the production',

    '(Title: East Zorra-Tavistock) East Zorra-Tavistock East Zorra-Tavistock '
    'is a township in southwestern Ontario, Canada, formed on 1 January 1975 '
    'through the amalgamation of the Township of East Zorra and the Village of '
    'Tavistock. It is part of Oxford County. The township had a population of '
    '6,836 in the Canada 2011 Census. The township is governed by a Mayor '
    '(Don McKay acclaimed at November 2006 election ), a Deputy Mayor '
    '(Maureen Ralph), and 5 Councillors over three geographic wards: The '
    'township includes the population centres of Braemar, Cassel, East Zorra, '
    'Hickson, Huntingford, Innerkip, Perry Mine, Perrys Lane, Strathallan, '
    'Tavistock, Tollgate, Willow Lake, and Woodstock',

    '(Title: FC Robo) FC Robo FC Robo International, owners of FC Robo Queens '
    'is a privately owned professional football club from Lagos, Nigeria. '
    'Founded on the 19th of April, Osahon Emmanuel Orobosa, a veteran of the '
    'Nigerian football league, primarily as a football academy for boys but '
    'soon expanded to accommodate soon expanded to accommodate girls/women '
    'program, a decision which has since proven to be very positive for the '
    'club as her current popularity and growing-base (Nationally and '
    'Internationally) is largely due to the successful exploits of her female '
    'team (FC Robo Queens). FC Robo Queens is a women\'s association football '
    'club based',

    '(Title: Omar Bongo) M\'ba how to give government ministries to different '
    'tribal groups so that someone from every important group had a '
    'representative in the government. Bongo had no ideology beyond '
    'self-interest, but there was no opposition with an ideology either. He '
    'ruled by knowing how the self-interest of others could be manipulated. He '
    'was skilled at persuading opposition figures to become his allies. He '
    "offered critics modest slices of the nation's oil wealth, co-opting or "
    'buying off opponents rather than crushing them outright. He became the '
    "most successful of all Africa's Francophone leaders, comfortably extending "
    'his political dominance into the fifth decade".',

    '(Title: Constantin Rădulescu-Motru) Liberalism ("see Right Hegelians and '
    "Left Hegelians\"). Owing to Wundt's \"Völkerpsychologie\", "
    'Rădulescu-Motru dedicated much of his work to assessing and defining '
    'nationalism in Romanian social context. Concentrating his analysis on the '
    'impact of modernization and Westernization, he argued for a need to adapt '
    'forms to the Romanian ethnicity (which he defined through heredity), and '
    'represented as the true social fundament (the "community of spirit"). He '
    'supported the existence of human races and differences among them, as '
    'well as eugenics, even after the defeat of Nazi Germany led to the '
    'abandonment of such theories in the mainstream scientific world. In his',
]

# Fake document IDs to match the paper's format
DISTRACTING_IDS = [
    13629136, 6533118, 1819721, 4193364, 12738999,
    13629133, 12738978, 1988390, 3354343, 4646105,
    12537869, 12738986,
]
RANDOM_IDS = [
    2914497, 3506350, 15459755, 18715636, 10576735,
    17410596, 16399688, 3836229, 6023563, 20058259,
    2382850, 8927376,
]
GOLD_ID = 20995349


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def seed_everything(seed: int = 10):
    random.seed(seed)
    os.environ["PYTHONHASHSEED"] = str(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed(seed)
        torch.cuda.manual_seed_all(seed)
        torch.backends.cudnn.benchmark = False
        torch.backends.cudnn.deterministic = True


def get_device() -> torch.device:
    """Pick best available device: CUDA > MPS > CPU."""
    if torch.cuda.is_available():
        return torch.device("cuda:0")
    if torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


def build_prompt(
    doc_ids: List[int],
    doc_texts: List[str],
    gold_id: int,
    gold_text: str,
    gold_position: int,
    question: str,
    answer: str,
    answer_prefix: str = "Answer:",
) -> tuple[str, int]:
    """Build a prompt in the paper's format. Returns (prompt_string, gold_index)."""
    all_ids = list(doc_ids)
    all_texts = list(doc_texts)
    all_ids.insert(gold_position, gold_id)
    all_texts.insert(gold_position, gold_text)

    docs_str = "\n".join(
        f"Document [{did}]{text}" for did, text in zip(all_ids, all_texts)
    )

    prompt = (
        f"{INSTRUCTION}\n"
        f"Documents:\n"
        f"{docs_str}\n"
        f"Question: {question}\n"
        f"{answer_prefix} {answer}"
    )
    return prompt, gold_position


def build_shuffled_prompt(
    doc_ids: List[int],
    doc_texts: List[str],
    gold_id: int,
    gold_text: str,
    gold_position: int,
    question: str,
    answer: str,
    answer_prefix: str = "Answer:",
) -> tuple[str, int]:
    """Build prompt with shuffled document order. Returns (prompt_string, new_gold_index)."""
    all_ids = list(doc_ids)
    all_texts = list(doc_texts)
    all_ids.insert(gold_position, gold_id)
    all_texts.insert(gold_position, gold_text)

    combined = list(zip(all_ids, all_texts))
    random.shuffle(combined)
    shuffled_ids, shuffled_texts = zip(*combined)

    new_gold_idx = list(shuffled_ids).index(gold_id)

    # Build a mapping from shuffled position -> original position
    # so we can label the x-axis with original doc indices
    original_order = list(doc_ids)
    original_order.insert(gold_position, gold_id)
    shuffled_labels = []
    for sid in shuffled_ids:
        orig_pos = original_order.index(sid)
        shuffled_labels.append(f"Doc_{orig_pos}")

    docs_str = "\n".join(
        f"Document [{did}]{text}" for did, text in zip(shuffled_ids, shuffled_texts)
    )

    prompt = (
        f"{INSTRUCTION}\n"
        f"Documents:\n"
        f"{docs_str}\n"
        f"Question: {question}\n"
        f"{answer_prefix} {answer}"
    )
    return prompt, new_gold_idx, shuffled_labels


# ---------------------------------------------------------------------------
# Attention extraction (adapted from notebook)
# ---------------------------------------------------------------------------
@torch.no_grad()
def get_answer_attention_to_documents(
    generated_string: str,
    tokenizer: AutoTokenizer,
    model: AutoModelForCausalLM,
    device: torch.device,
    answer_prefix: str = "Answer:",
) -> List[np.ndarray]:
    output_tokenized = tokenizer(
        generated_string,
        padding=True,
        truncation=True,
        return_tensors="pt",
    ).to(device)

    outputs = model(
        **output_tokenized,
        output_attentions=True,
    )

    def find_documents_positions(s):
        pattern = r"Document \[\d+\].*?(?=Document|Question:)"
        matches = re.finditer(pattern, s, re.DOTALL)
        positions = [(m.start(), m.end()) for m in matches]
        return [
            (output_tokenized.char_to_token(i), output_tokenized.char_to_token(j))
            for i, j in positions
        ]

    def find_answer_positions(s):
        escaped = re.escape(answer_prefix)
        pattern = rf"^\s*{escaped}\s*(.*)$"
        matches = list(re.finditer(pattern, s, re.MULTILINE))
        assert len(matches) == 1, f"Expected 1 answer, found {len(matches)}"
        m = matches[0]
        start = m.start() + len(answer_prefix)
        end = min(m.end(), len(s) - 1)
        return output_tokenized.char_to_token(start), output_tokenized.char_to_token(end)

    documents_token_positions = find_documents_positions(generated_string)
    answer_token_positions = find_answer_positions(generated_string)

    answer_attention_to_documents = []
    for hidden_layer in outputs.attentions:
        attention_np = hidden_layer.float()
        attention_np = attention_np.mean(1)  # avg over heads
        attention_np = attention_np.squeeze(0).detach().cpu().numpy()

        answer_attention = attention_np[
            answer_token_positions[0] : answer_token_positions[1]
        ]
        answer_attention = answer_attention.mean(0)

        doc_avgs = np.array(
            [answer_attention[i:j].mean() for i, j in documents_token_positions]
        )
        normalized_doc_avgs = doc_avgs / doc_avgs.sum()
        answer_attention_to_documents.append(normalized_doc_avgs)

    del outputs
    gc.collect()
    if torch.cuda.is_available():
        torch.cuda.empty_cache()

    return answer_attention_to_documents


# ---------------------------------------------------------------------------
# Plotting (adapted from notebook)
# ---------------------------------------------------------------------------
def plot_attentions(
    answer_attention_to_documents: List[np.ndarray],
    gold_position: int,
    title: str,
    save_path: str = None,
    labels: List[str] = None,
) -> None:
    plt.figure(figsize=(10, 8))

    num_docs = len(answer_attention_to_documents[0])
    if labels is not None:
        ticks = list(labels)
    else:
        ticks = [f"Doc_{i}" for i in range(num_docs)]
    if gold_position is not None and gold_position < num_docs:
        ticks[gold_position] = "GOLD"

    sns.heatmap(
        answer_attention_to_documents, annot=False, cmap="Blues", xticklabels=ticks
    )

    gold_color = (212 / 255, 175 / 255, 55 / 255)
    ax = plt.gca()
    for label in ax.get_xticklabels():
        if label.get_text() == "GOLD":
            label.set_color(gold_color)
            label.set_fontweight("bold")

    plt.xticks(rotation=20)
    plt.yticks(rotation=0)
    plt.xlabel("Documents in Context")
    plt.ylabel("Attention Layers")
    plt.title(title)
    plt.tight_layout()

    if save_path:
        os.makedirs(os.path.dirname(save_path), exist_ok=True)
        plt.savefig(save_path, dpi=300)
        print(f"Saved: {save_path}")
    else:
        plt.show()
    plt.close()


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(
        description="Reproduce and extend Figure 3 attention analysis"
    )
    parser.add_argument(
        "--output-dir",
        default="images",
        help="Directory to save output images (default: images)",
    )
    parser.add_argument(
        "--model",
        default=DEFAULT_MODEL,
        choices=MODELS.keys(),
        help=f"Which LLM to use (default: {DEFAULT_MODEL}). "
             "phi2 (2.7B) fits on 8GB RAM; others need ≥16GB.",
    )
    parser.add_argument(
        "--num-docs",
        type=int,
        default=None,
        help="Number of distracting/random docs to use (default: 4 on MPS/CPU, 12 on CUDA). "
             "Fewer docs = less memory. Gold doc is always added on top.",
    )
    args = parser.parse_args()

    model_info = MODELS[args.model]
    model_id = model_info["id"]
    model_max_length = model_info["max_length"]
    answer_prefix = model_info["answer_prefix"]

    seed_everything(SEED)
    device = get_device()
    print(f"Using device: {device}")

    # Subset documents to fit in memory
    num_docs = args.num_docs
    if num_docs is None:
        num_docs = 12 if device.type == "cuda" else 4
    num_docs = min(num_docs, len(DISTRACTING_DOCS))
    dist_docs = DISTRACTING_DOCS[:num_docs]
    dist_ids = DISTRACTING_IDS[:num_docs]
    rand_docs = RANDOM_DOCS[:num_docs]
    rand_ids = RANDOM_IDS[:num_docs]
    gold_position = num_docs  # gold goes last
    print(f"Using {num_docs} context docs + 1 gold = {num_docs + 1} total")

    # Load model
    print(f"Loading {model_id}...")
    model_config = AutoConfig.from_pretrained(model_id, trust_remote_code=True)
    model_config.max_seq_len = model_max_length

    load_kwargs = dict(
        trust_remote_code=True,
        config=model_config,
        torch_dtype=torch.float16,
        attn_implementation="eager",  # needed for output_attentions
    )
    if device.type == "cuda":
        from transformers import BitsAndBytesConfig
        load_kwargs["quantization_config"] = BitsAndBytesConfig(
            load_in_4bit=True,
            bnb_4bit_quant_type="nf4",
            bnb_4bit_use_double_quant=True,
            bnb_4bit_compute_dtype=torch.bfloat16,
        )
        load_kwargs["device_map"] = "auto"
    else:
        # CPU: no device_map, load directly
        load_kwargs["device_map"] = None

    model = AutoModelForCausalLM.from_pretrained(model_id, **load_kwargs)
    if device.type != "cuda":
        model = model.to(device)
    model.eval()

    tokenizer = AutoTokenizer.from_pretrained(
        model_id,
        padding_side="left",
        truncation_side="left",
        model_max_length=model_max_length,
    )
    tokenizer.pad_token = tokenizer.eos_token

    # -- 1. Distracting: original order (gold last) --
    print("\n--- Distracting docs (original order) ---")
    prompt_dist_orig, gold_idx_dist_orig = build_prompt(
        dist_ids, dist_docs,
        GOLD_ID, GOLD_DOC, gold_position=gold_position,
        question=QUESTION, answer="Han Solo",  # wrong answer as in paper
        answer_prefix=answer_prefix,
    )
    attn_dist_orig = get_answer_attention_to_documents(
        prompt_dist_orig, tokenizer, model, device, answer_prefix=answer_prefix,
    )
    plot_attentions(
        attn_dist_orig, gold_idx_dist_orig,
        title="Attention from Answer to Documents (Distracting — Original)",
        save_path=os.path.join(args.output_dir, "attention_distracting_original.png"),
    )

    # -- 2. Distracting: shuffled order --
    print("\n--- Distracting docs (shuffled order) ---")
    seed_everything(42)  # different seed for shuffle
    prompt_dist_shuf, gold_idx_dist_shuf, dist_shuf_labels = build_shuffled_prompt(
        dist_ids, dist_docs,
        GOLD_ID, GOLD_DOC, gold_position=gold_position,
        question=QUESTION, answer="Han Solo",
        answer_prefix=answer_prefix,
    )
    attn_dist_shuf = get_answer_attention_to_documents(
        prompt_dist_shuf, tokenizer, model, device, answer_prefix=answer_prefix,
    )
    plot_attentions(
        attn_dist_shuf, gold_idx_dist_shuf,
        title="Attention from Answer to Documents (Distracting — Shuffled)",
        save_path=os.path.join(args.output_dir, "attention_distracting_shuffled.png"),
        labels=dist_shuf_labels,
    )

    # -- 3. Random: original order (gold at position 12, last) --
    print("\n--- Random docs (original order) ---")
    seed_everything(SEED)
    prompt_rand_orig, gold_idx_rand_orig = build_prompt(
        rand_ids, rand_docs,
        GOLD_ID, GOLD_DOC, gold_position=gold_position,
        question=QUESTION, answer="Lando Calrissian",  # correct answer
        answer_prefix=answer_prefix,
    )
    attn_rand_orig = get_answer_attention_to_documents(
        prompt_rand_orig, tokenizer, model, device, answer_prefix=answer_prefix,
    )
    plot_attentions(
        attn_rand_orig, gold_idx_rand_orig,
        title="Attention from Answer to Documents (Random — Original)",
        save_path=os.path.join(args.output_dir, "attention_random_original.png"),
    )

    # -- 4. Random: shuffled order --
    print("\n--- Random docs (shuffled order) ---")
    seed_everything(42)
    prompt_rand_shuf, gold_idx_rand_shuf, rand_shuf_labels = build_shuffled_prompt(
        rand_ids, rand_docs,
        GOLD_ID, GOLD_DOC, gold_position=gold_position,
        question=QUESTION, answer="Lando Calrissian",
        answer_prefix=answer_prefix,
    )
    attn_rand_shuf = get_answer_attention_to_documents(
        prompt_rand_shuf, tokenizer, model, device, answer_prefix=answer_prefix,
    )
    plot_attentions(
        attn_rand_shuf, gold_idx_rand_shuf,
        title="Attention from Answer to Documents (Random — Shuffled)",
        labels=rand_shuf_labels,
        save_path=os.path.join(args.output_dir, "attention_random_shuffled.png"),
    )

    print("\nDone! All images saved to:", args.output_dir)


if __name__ == "__main__":
    main()
