// ============================================================
//  slides/09a_practice_experiment.typ  –  Experiment setup
// ============================================================
#import "../helpers.typ": *

== Randomness in Practice — Experiment

*Sub-question:*
#v(3pt)
#finding-box[
  Does padding retrieved documents with random noise improve accuracy in a realistic end-to-end RAG setting?
]

#v(10pt)

*Setup:*
#v(3pt)
- Retrieve top-$k$ documents using an IR system (no oracle — the retrieved set is a mix of #tag-relevant, #tag-distracting, and possibly #tag-gold)
- Pad remaining context window with random documents #tag-random
- Prompt: #prompt("I", "■■■", "▲/●/★", "Q") — noise *before* retrieved docs
- Tested on *Llama2* (Table 3) and *Falcon* (Table 5)
- Both *Contriever* (dense) and *BM25* (sparse) retrievers
- Additional noise types: *Reddit* posts and *random words* (nonsensical sentences)
- Evaluated on NQ-open *test set* (earlier experiments used training set)
