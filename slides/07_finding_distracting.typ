// ============================================================
//  slides/07_finding_distracting.typ  –  Common perception
// ============================================================
#import "../helpers.typ": *

== Finding 2: Distracting Documents

#set text(size: 16pt)

*Common perception:*
#v(3pt)
- Retrieve top-$k$ documents by similarity score
- Semantically close documents are helpful for the LLM
- More top-scoring documents → better answers

#v(10pt)

#info-box[
  In practice, retrievers often return documents that are *semantically aligned* with the query but *do not contain the answer*. These are called *distracting documents* #tag-distracting.
]
