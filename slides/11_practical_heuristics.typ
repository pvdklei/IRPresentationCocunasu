// ============================================================
//  slides/11_practical_heuristics.typ  –  Takeaways for practitioners
// ============================================================
#import "../helpers.typ": *

== Practical Heuristics from the Paper

  #v(4pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 22pt,

    // ── left ──
    [
      *Proposed retrieval strategy:*
      #v(10pt)

      - Retrieve *3–5 documents* with your IR system
      - Place them *near the query* in the prompt
      - Fill the remaining context with *random documents*, far from the query
      #v(8pt)
      Result: #prompt("I", "N", "G/R", "Q")
    ],

    // ── right ──
    [
      *Why not retrieve more?*
      #v(6pt)
      #block(
        fill: rgb("#f4f6f7"),
        stroke: c-muted + 0.5pt,
        radius: 5pt,
        inset: 12pt,
      )[
        #set text(size: 15pt)
        More retrieved docs → increasing chance of *distracting* content → accuracy degrades.

      ]

      // #v(10pt)

      // *Key insight for the field:*
      // #v(6pt)
      // #finding-box[
      //  Retrieval quality for RAG is *not* the same as classic IR relevance ranking. A retriever optimised purely for top-$k$ relevance may *hurt* the downstream LLM. New retrieval objectives are needed.]
    ],
  )
