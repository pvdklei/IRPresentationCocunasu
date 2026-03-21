// ============================================================
//  slides/04_document_types.typ  –  Taxonomy of document types
// ============================================================
#import "../helpers.typ": *

== Document Taxonomy

  #grid(
    columns: (1fr),
    gutter: 22pt,
    // ── left: four types ──
    [
      The paper formalises four document types a retriever can return:

      #v(10pt)

      #block(inset: (left: 6pt))[
        #tag-gold #h(4pt) - the *ground-truth passage* containing the answer. \
        #v(6pt)
        #tag-relevant #h(4pt) - other passages that *also contain the answer* #text(size: 0.85em, fill: c-muted)[(not directly tested)]. \
        #v(6pt)
        #tag-distracting #h(4pt) - semantically close to the query but *no answer* (top-$k$ but wrong). \
        #v(6pt)
        #tag-random #h(4pt) - *unrelated* to the query; noise.
      ]
    ],
    // ── right: prompt notation + example ──

  )
