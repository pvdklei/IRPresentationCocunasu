// ============================================================
//  slides/12_course_connection.typ  –  Tie back to IR1 lectures
// ============================================================
#import "../helpers.typ": *

== Connecting to the Course

  #grid(
    columns: (1fr, 1fr),
    gutter: 22pt,

    // ── left ──
    [
      #set text(size: 15pt)
      *Concepts related to the results:*

      #v(4pt)

      #block(inset: (left: 6pt))[
        *Lost in the Middle* #text(size: 13pt, fill: c-muted)[] \
        #text(size: 14pt, fill: c-muted)[] \
        #v(4pt)

        *Semi-relevant documents act as a distractor* #text(size: 13pt, fill: c-muted)[] \
        #text(size: 14pt, fill: c-muted)[] \
        #v(4pt)
      ]
    ],

    // ── right ──
    [
      #set text(size: 15pt)
      *Additionally:*

      #v(4pt)
      #info-box[
        Instead of *document relevance to query*,
        RAG requires optimising for *LLM generation quality given the prompt*.
      ]

      
      ],
  )
