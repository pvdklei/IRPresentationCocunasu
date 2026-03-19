// ============================================================
//  slides/04_document_types.typ  –  Taxonomy of document types
// ============================================================
#import "../helpers.typ": *

== A Taxonomy of Retrieved Documents

  #grid(
    columns: (1fr, 1fr),
    gutter: 22pt,
    // ── left: four types ──

    // ── right: prompt notation + example ──
    [
      *Prompt structure notation:*

      #v(6pt)
      #block(
        fill: rgb("#f4f6f7"),
        stroke: c-muted + 0.5pt,
        radius: 5pt,
        inset: 12pt,
      )[
        #set text(size: 15pt)
        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          [*I*], [Task instruction],
          [], [----------------------],
          [*G*], [Gold document],
          [*R*], [Relevant documents],
          [*D*], [Distracting documents],
          [*N*], [Noisy documents],
          [], [----------------------],
          [*Q*], [The query],
        )

        #v(8pt)
        Example: #prompt("I", "D", "G", "Q") means: instruction, then distracting docs, then gold, then query.
      ]

      #v(8pt)
      #info-box[
        The *position* of each document relative to Q will matter greatly.
      ]
    ],
  )
