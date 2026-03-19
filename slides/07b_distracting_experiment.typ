// ============================================================
//  slides/07b_distracting_experiment.typ  –  Experiment setup
// ============================================================
#import "../helpers.typ": *

== Distracting Documents — Experiment

*Sub-question:*
#v(3pt)
#finding-box[
  How do distracting documents #tag-distracting affect RAG performance?
]

#v(10pt)

*Setup:*
#v(3pt)
- Oracle setting: the gold document #tag-gold is always in the prompt
- Add 0–10 distracting documents (high retrieval score, no answer)
- Test across all four LLMs and three positions (far, mid, near)
- Schematically: #prompt("I", "▲...", "★", "Q")
