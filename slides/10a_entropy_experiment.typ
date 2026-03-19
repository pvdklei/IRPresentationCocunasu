// ============================================================
//  slides/10a_entropy_experiment.typ  –  Attention entropy results
// ============================================================
#import "../helpers.typ": *

== Entropy Collapse — Evidence

#grid(
  columns: (1fr, 1.4fr),
  gutter: 16pt,

  // ── left: images stacked ──
  [
    #set text(size: 10pt)
    *Lower entropy*:
    #image("../images/lower_entropy.png", height: 35%)

    *Higher entropy*:
    #image("../images/higher_entropy.png", height: 35%)
  ],

  // ── right: experiment + result ──
  [
    #set text(size: 15pt)
    *Attention entropy experiment:*

    #v(6pt)
    Measured on *Llama2-7b* in the oracle setting.

    #v(4pt)
    Compare the attention entropy of:
    #v(2pt)
    - Only gold: #prompt("I", "★", "Q")
    - With noise: #prompt("I", "■■", "★", "Q")

    #v(8pt)

    #block(
      fill: c-green.lighten(82%),
      stroke: c-green + 0.8pt,
      radius: 4pt,
      inset: 10pt,
    )[
      Attention entropy *increases ~3x* when random documents are added to the prompt.
    ]

    #v(8pt)

    #set text(size: 14pt)
    Higher entropy = attention is more *distributed* across documents, rather than collapsing onto a narrow, potentially misleading region.
  ],
)
