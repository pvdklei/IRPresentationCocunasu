// ============================================================
//  slides/03b_not_true.typ  –  Assumptions debunked
// ============================================================
#import "../helpers.typ": *

== Not So Fast

*These assumptions are not actually true:*
#v(6pt)

#set text(size: 17pt)
- #strike[Feed top-$k$ highest-scoring retrieved docs to the LLM]
- #strike[More semantically relevant == better]
- #strike[Our current retrieval systems are good at this]

#v(14pt)

#info-box[
  We already discussed this in class — and this paper was referenced as evidence that common retrieval assumptions break down in the RAG setting.
]

#v(10pt)

#set text(size: 16pt)
So what *does* make a good retriever for RAG? Let's look at the study.
