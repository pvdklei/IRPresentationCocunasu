// ============================================================
//  slides/10_why_noise_helps.typ  –  Entropy collapse background
// ============================================================
#import "../helpers.typ": *

== Why Does Noise Help? Entropy Collapse

#set text(size: 16pt)

*From prior work* (Attanasio et al., 2022; Hoffmann et al., 2023):

#v(4pt)
- There are cases where pathologically *low attention entropy* causes LLMs to generate degenerate outputs with a sharp decrease in performance
- These episodes are called *entropy collapse*
- Low entropy = the model focuses too narrowly on a small region of the context, ignoring relevant information

#v(14pt)

*The authors' hypothesis:*
#v(4pt)
#key-box[
  By adding random documents to the context, we are *better conditioning* the generative function $p_theta (y | dot, d)$, inducing enhanced accuracy. Random documents may act as "attention anchors" that *prevent entropy collapse* — spreading the model's attention more evenly and reducing degenerate focus on irrelevant passages.
]
