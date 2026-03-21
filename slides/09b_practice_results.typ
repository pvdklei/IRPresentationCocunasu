// ============================================================
//  slides/09b_practice_results.typ  –  Summarized results
// ============================================================
#import "../helpers.typ": *

== Experiment 4: Practice Results

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,

  // ── left ──
  [
    #set text(size: 15pt)
    *Noise still works, even better:*
    #v(4pt)
    - Adding noise improves accuracy up to *+35%* (Contriever, 4 retrieved docs) and *+44%* (BM25)
    - Almost always beneficial regardless of number of retrieved docs
    - Filling the context window with noise until full yields best results

    #v(6pt)
    #block(
      fill: rgb("#f4f6f7"),
      stroke: c-muted + 0.5pt,
      radius: 5pt,
      inset: (x: 12pt, y: 8pt),
    )[
      #set text(size: 14pt)
      #grid(
        columns: (auto, 1fr, auto),
        gutter: (6pt, 4pt),
        align: (left, left, right),
        [], text(weight: "bold")[Contriever], [],
        text(fill: c-muted)[without noise], [retrieve 4 docs], text(fill: c-muted)[0.187],
        text(fill: c-green)[with noise], [retrieve 4 + fill rest with noise], text(fill: c-green, weight: "bold")[0.253 #text(size: 11pt)[(+35%)]],
        [], [], [],
        [], text(weight: "bold")[BM25], [],
        text(fill: c-muted)[without noise], [retrieve 4 docs], text(fill: c-muted)[0.203],
        text(fill: c-green)[with noise], [retrieve 4 + fill rest with noise], text(fill: c-green, weight: "bold")[0.293 #text(size: 11pt)[(+44%)]],
      )
    ]
  ],

  // ── right ──
  [
    #set text(size: 15pt)
    *Broader than expected:*
    #v(4pt)
    - *Falcon* now benefits from noise, unlike in the oracle setting where it showed no improvement
    - Holds for *BM25* too. BM25 shows 3-4 pp higher accuracy on average (higher top-$k$ accuracy)
    - *Noise source doesn't matter*: Reddit posts and random words work at least as well. Reddit even adds +9% over Wikipedia noise

    #v(6pt)
    #warn-box[
      *Sweet spot:* retrieve *3-5 docs*, pad remaining context with noise. More docs → more distractors.
    ]
  ],
)
