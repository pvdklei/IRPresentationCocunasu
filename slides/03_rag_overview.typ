// ============================================================
//  slides/03_rag_overview.typ  –  Common assumptions & gap
// ============================================================
#import "../helpers.typ": *

== But?

*Common assumption:*
#v(6pt)
- Feed top-$k$ highest-scoring retrieved docs to the LLM
- More semantically relevant == better
- Our current retrieval systems are good at this

#v(16pt)

#info-box[
  *But:* the retriever's role itself has received surprisingly little systematic study.
]
