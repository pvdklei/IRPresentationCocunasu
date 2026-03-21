// ============================================================
//  slides/09_finding_noise_practice.typ  –  Finding 4 intro
// ============================================================
#import "../helpers.typ": *

== Experiment 4: Noise in Practice

#set text(size: 16pt)

*So far - oracle setting:*
#v(3pt)
- Gold document #tag-gold is *always* present in the prompt
- We control exactly which documents are added
- Not representative of a real RAG pipeline

#v(10pt)

*In practice:*
#v(3pt)
- You retrieve top-$k$ documents: a mix of relevant, distracting, and possibly gold
- No guarantee the gold document is even retrieved
- You don't know which document is which

#v(10pt)

#info-box[
  Can random noise still improve accuracy when the prompt contains *real retrieved documents* instead of a hand-picked gold document?
]
