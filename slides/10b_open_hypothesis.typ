// ============================================================
//  slides/10b_open_hypothesis.typ  –  Open hypothesis disclaimer
// ============================================================
#import "../helpers.typ": *

== Entropy Collapse — Open Question

#v(20pt)

#warn-box[
  #set text(size: 16pt)
  The entropy collapse hypothesis shows *correlation* (noise → higher entropy → better accuracy) but *not causation*. The authors explicitly note: _"although these experiments show a pattern, we cannot yet answer this question in a definitive manner."_
]

#v(14pt)

#set text(size: 16pt)
- Investigating *why* LLMs respond this way to noise is outside the scope of the paper
- The paper focuses on the *retriever* component — not the inner workings of the LLM
- Flagged as an important direction for *future work*: understanding what characteristics of noise make it advantageous
