// ============================================================
//  slides/05_experimental_setup.typ  –  Methodology overview
// ============================================================
#import "../helpers.typ": *

== Experimental Setup

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 18pt,

    // ── Dataset ──
    block(
      fill: c-lblue,
      stroke: c-blue + 0.8pt,
      radius: 5pt,
      inset: 12pt,
    )[
      #text(weight: "bold", fill: c-navy)[Dataset]
      #v(6pt)
      *NQ-open* (Natural Questions)
      #v(4pt)
      - ~21M Wikipedia passages (100 words each)
      - 2,889 test queries
      - Answers ≤ 5 tokens
      - Open-domain Q&A
    ],

    // ── Generators ──
    block(
      fill: c-green.lighten(82%),
      stroke: c-green + 0.8pt,
      radius: 5pt,
      inset: 12pt,
    )[
      #text(weight: "bold", fill: c-green.darken(20%))[Generators]
      #v(6pt)
      - *Llama2-7b* (main model)
      - Phi-2
      - Falcon-7b
      - Mosaic MPT-7b
      #v(4pt)
      All open-source, 4-bit quantised \
      Greedy decoding, max 15 tokens
    ],

    // ── Retrievers ──
    block(
      fill: c-orange.lighten(80%),
      stroke: c-orange + 0.8pt,
      radius: 5pt,
      inset: 12pt,
    )[
      #text(weight: "bold", fill: c-orange.darken(20%))[Retrievers]
      #v(6pt)
      - *Contriever* (dense, bi-encoder)
      - *BM25* (sparse, term-based)
      #v(4pt)
      Dense vs.\ sparse comparison
    ],
  )

  #v(10pt)

  #block(
    fill: rgb("#f4f6f7"),
    stroke: c-muted + 0.5pt,
    radius: 5pt,
    inset: (x: 14pt, y: 10pt),
    width: 100%,
  )[
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      align: horizon,
      text(weight: "bold")[Metric:],
      [Accuracy],
      // text(weight: "bold")[Significance:],
      // [Wilcoxon signed-rank test ($p < 0.01$) throughout],
    )
  ]
