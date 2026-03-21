// ============================================================
//  slides/03c_outline.typ  –  Overview of the four findings
// ============================================================
#import "../helpers.typ": *

== Outline

#set text(size: 16pt)

To answer this research question, the study conducts four sub-experiments:

#v(8pt)

#block(inset: (left: 6pt))[
  *Experiment 1: Position of the answer-containing document* \
  #text(size: 14pt, fill: c-muted)[Does it matter where in the prompt the answer-containing document is placed?]
  #v(8pt)

  *Experiment 2: Distracting documents* \
  #text(size: 14pt, fill: c-muted)[What happens when semantically close, but non-answer documents are added?]
  #v(8pt)

  *Experiment 3: Random noise* \
  #text(size: 14pt, fill: c-muted)[Can adding completely random documents actually help?]
  #v(8pt)

  *Experiment 4: Random noise (in a more realistic setting)* \
  #text(size: 14pt, fill: c-muted)[Does the noise effect hold in a realistic end-to-end RAG pipeline?]
]

#v(8pt)

We will first cover the experimental setup, then go through each sub-experiment.
