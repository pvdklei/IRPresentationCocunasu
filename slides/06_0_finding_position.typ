// ============================================================
//  slides/06_finding_position.typ  –  Finding 1: position matters
// ============================================================
#import "../helpers.typ": *

== Finding 1: Position of the Gold Document Matters

  #grid(
    columns: (1fr),
    gutter: 24pt,

    // ── left ──
    [
      Three positions tested for the gold document #tag-gold relative to the query *Q*:

      #v(6pt)

      #block(inset: (left: 8pt))[
        #text(fill: c-green, weight: "bold")[Near:] #h(4pt) #prompt("I", "D", "G", "Q") \
        Gold adjacent to query \ #v(2pt)
        #text(fill: c-orange, weight: "bold")[Far:] #h(4pt) #prompt("I", "G", "D", "Q") \
        Gold at start of prompt \ #v(2pt)
        #text(fill: c-red, weight: "bold")[Mid:] #h(4pt) #prompt("I", "D", "G", "D", "Q") \
        Gold buried in the middle
      ]

      #v(10pt)

      #finding-box[
        *Near > Far > Mid.* The middle of the context is hardest to attend to.
      ]
    ],

    // ── right ──
  )
