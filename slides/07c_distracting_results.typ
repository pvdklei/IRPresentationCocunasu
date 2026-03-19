// ============================================================
//  slides/07c_distracting_results.typ  –  Key result
// ============================================================
#import "../helpers.typ": *

== Distracting Documents — Results

*Baseline comparison (Llama2, Contriever, Near):*

#v(6pt)
#block(
  fill: rgb("#f4f6f7"),
  stroke: c-muted + 0.5pt,
  radius: 5pt,
  inset: (x: 12pt, y: 8pt),
)[
  #set text(size: 14pt)
  #grid(
    columns: (1fr, auto),
    gutter: 6pt,
    [Only gold #prompt("I", "★", "Q")],
    text(fill: c-green, weight: "bold")[0.564],
    [Gold + 1 distracting #prompt("I", "▲", "★", "Q")],
    text(fill: c-red, weight: "bold")[↓ 0.428],
    [Gold + 2 distracting #prompt("I", "▲▲", "★", "Q")],
    text(fill: c-red, weight: "bold")[↓↓ 0.397],
  )
]

#v(8pt)

#surprise-box[
  Distracting documents #tag-distracting (high retrieval score, *no answer*) *decrease* LLM accuracy vs. using only the gold document.
]

#v(6pt)

#finding-box[
  The *retriever's ranking score is not a reliable signal* for downstream LLM usefulness. High retrieval score ≠ helpful in the prompt.
]
