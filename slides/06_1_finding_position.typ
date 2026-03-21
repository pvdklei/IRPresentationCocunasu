// ============================================================
//  slides/06_finding_position.typ  –  Finding 1: position matters
// ============================================================
#import "../helpers.typ": *

== Experiment 1: Gold Position

  #grid(
    columns: (1fr, 1fr),
    gutter: 24pt,

    // ── left ──

    // ── right ──
    [
      *Intuition from attention patterns:*

      #v(8pt)
      - The *"Lost in the Middle"* effect (Liu et al., 2023)
      - Attention scores are *highest near the query*, and also relatively high at the very start of the prompt
      // - The *middle* of the context gets the least attention: a U-shaped curve

      #v(6pt)

      #warn-box[
        *Practical implication:* place relevant docs *immediately before* the query. Start of prompt is second best.
      ]

      #v(4pt)
      #text(size: 13pt, fill: c-muted)[Consistent across all tested models (Llama2, Phi-2, Falcon, MPT).]
    ],

    [
      #figure(
  image("../tables/lost_in_the_middle.png", width: 80%),
  caption: [
  ],
)

    ],
  )
