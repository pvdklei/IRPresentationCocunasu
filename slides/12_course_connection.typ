// ============================================================
//  slides/12_course_connection.typ  –  Tie back to IR1 lectures
// ============================================================
#import "../helpers.typ": *

== Course Connection

  #grid(
    columns: (1fr, 1fr),
    gutter: 22pt,

    // ── left ──
    [
      #set text(size: 15pt)
      *Course concepts in this paper:*

      #v(4pt)

      #block(inset: (left: 6pt))[
        *RAG* #text(size: 13pt, fill: c-muted)[(Week 4)] \
        #text(size: 14pt, fill: c-muted)[The RAG lecture introduced this exact problem: semi-relevant docs as distractors and Lost in the Middle. This paper provides the empirical deep-dive.] \
        #v(4pt)

        *Dense retrieval - Contriever* #text(size: 13pt, fill: c-muted)[(Week 3)] \
        #text(size: 14pt, fill: c-muted)[Bi-encoder from the Dense Retrieval lecture; used as the main dense retriever in the paper.] \
        #v(4pt)

        *BM25* #text(size: 13pt, fill: c-muted)[(Weeks 1 & 3)] \
        #text(size: 14pt, fill: c-muted)[TF-IDF weighting (Week 1) → BM25 as sparse retriever (LSR lecture). Paper compares sparse vs.\ dense for RAG.] \
        #v(4pt)

        *Recall@$k$* #text(size: 13pt, fill: c-muted)[(Week 2)] \
        #text(size: 14pt, fill: c-muted)[Standard metric from the Evaluation lecture, but the paper shows high Recall@$k$ does *not* guarantee good LLM accuracy.] \
      ]
    ],

    // ── right ──
    [
      #set text(size: 15pt)
      *What this paper adds beyond the course:*

      #v(4pt)
      #info-box[
        Classic IR optimises for *document relevance to query*.
        RAG requires optimising for *LLM generation quality given the prompt*.
        These are *not the same objective*.
      ]

      #v(6pt)
      The Week 4 RAG lecture flags distractors and Lost in the Middle as open challenges. This paper *quantifies* both, and reveals the surprising noise effect not discussed in the course.

      #v(6pt)
      #text(size: 13pt, fill: c-muted)[The paper's call for new retrieval objectives aligns with the course's progression: classical ranking (Weeks 1-2) → neural retrieval (Week 3) → generation-aware retrieval (Week 4).]
    ],
  )
