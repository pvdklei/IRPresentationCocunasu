// ============================================================
//  slides/03a_research_question.typ  –  Research question
// ============================================================
#import "../helpers.typ": *

== Research Question

#v(6pt)

#finding-box[
  _"What characteristics are desirable in a retriever to optimize prompt construction for RAG systems? Are current retrievers ideal?"_

  #v(4pt)
  Three dimensions studied: *type*, *position*, and *number* of documents.
]

#v(10pt)

*Contributions:*
#v(4pt)
+ First comprehensive study on how the _type_ of retrieved documents affects LLM performance in RAG
+ New retrieval heuristics based on the (unexpected) results
+ All code and data publicly released
