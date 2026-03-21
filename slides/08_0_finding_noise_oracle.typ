// ============================================================
//  slides/08_finding_noise_oracle.typ  –  Noise helps (oracle)
// ============================================================
#import "../helpers.typ": *

== Experiment 3: Noise Helps (Oracle)

  #grid(
    columns: (1fr),
    gutter: 24pt,

    // ── left ──
    [
      The gold document is always included.
      Random Wikipedia passages are added around it.

      #v(8pt)
      Prompt: #prompt("I", "N",  "N", "N", "G", "Q")

      #v(10pt)

      *Results (MPT-7b, Near):*
      #v(4pt)
      #block(
        fill: rgb("#f4f6f7"),
        stroke: c-muted + 0.5pt,
        radius: 5pt,
        inset: 12pt,
      )[
        #set text(size: 15pt)
        #grid(
          columns: (1fr, auto),
          gutter: 8pt,
          [Only gold #prompt("I", "G", "Q")],  text(fill: c-muted)[0.215],
          [+ 4 random docs],             text(fill: c-green, weight: "bold")[0.293],
        )
      ]

      #v(8pt)
      #surprise-box[
        *+8% accuracy* from adding documents that contain no answer at all
      ]
    ],

    // ── right ──
  )
