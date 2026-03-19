// ============================================================
//  slides/02b_rag_fix.typ  –  RAG as the fix
// ============================================================
#import "../helpers.typ": *

== Solution!

*Retrieval-Augmented Generation (RAG):*
#v(6pt)
- Use an IR system to retrieve relevant documents for the query
- Feed these documents into the LLM prompt as context

#v(12pt)

// Pipeline diagram
#block(
  fill: rgb("#f4f6f7"),
  stroke: c-muted + 0.5pt,
  radius: 6pt,
  inset: 14pt,
  width: 100%,
)[
  #set text(size: 16pt)
  #align(center)[
    #grid(
      columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
      gutter: 6pt,
      align: center + horizon,
      block(fill: c-lblue,        stroke: c-blue + 0.8pt, radius: 4pt, inset: 8pt)[*Query*],
      text(size: 22pt, fill: c-muted)[→],
      block(fill: c-gold.lighten(70%), stroke: c-gold + 0.8pt, radius: 4pt, inset: 8pt)[*Retriever*],
      text(size: 22pt, fill: c-muted)[→],
      block(fill: c-lblue,        stroke: c-blue + 0.8pt, radius: 4pt, inset: 8pt)[*Documents*],
      text(size: 22pt, fill: c-muted)[→],
      block(fill: c-gold.lighten(70%), stroke: c-gold + 0.8pt, radius: 4pt, inset: 8pt)[*Generator*],
      text(size: 22pt, fill: c-muted)[→],
      block(fill: c-lblue,        stroke: c-blue + 0.8pt, radius: 4pt, inset: 8pt)[*Answer*],
    )
  ]
]
