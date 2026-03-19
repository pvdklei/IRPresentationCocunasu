// ============================================================
//  slides/07e_distracting_attention.typ  –  Attention explanation
// ============================================================
#import "../helpers.typ": *

== Distracting Documents — Explanation

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,

  [
    #image("../images/figure3_attention_distraction.png", width: 85%)
    #v(2pt)
    #text(size: 11pt, fill: c-muted)[Figure 3: Attention from answer tokens to context documents in #prompt("I", "▲...", "★", "Q") (Llama2).]
  ],

  [
    #set text(size: 14pt)

    The paper's attention analysis shows the LLM *disproportionately attends* to distracting documents over the gold document, explaining the wrong answers.

    #v(6pt)

    #info-box[
      Semantically aligned documents compete for the model's attention — the LLM cannot distinguish between *relevant-with-answer* and *relevant-without-answer*.
    ]

    #v(6pt)

    #warn-box[
      *Note:* the most-attended document is Doc\_0 (first in prompt) and the gold is Doc\_12 (last, near the query). Is this a property of distracting docs, or does position itself drive attention? LLMs are known to attend more to the start and end of the context.
    ]
  ],
)
