// ============================================================
//  slides/09c_practice_tables.typ  –  Detailed results tables
// ============================================================
#import "../helpers.typ": *

== Randomness in Practice — Detailed Results

#set text(size: 11pt)

*Table 3 — Llama2:* Wikipedia noise + retrieved docs (Contriever vs BM25)
#v(1pt)
#image("../images/table3_random_in_practise.png", width: 100%)

#v(1pt)
#text(size: 10pt, fill: c-muted)[
  Rows = random docs added, columns = retrieved docs. Bold = best per column. (\*) = not significant vs. baseline.
]

== Randomness in Practice — Detailed Results (Falcon)

*Table 5 — Falcon-7b:* Reddit noise + retrieved docs #prompt("I", "■■■", "▲/●/★", "Q")

#v(4pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,

  [
    #image("../images/table5_falcon_in_practise.png", width: 100%)
  ],

  [
    #set text(size: 14pt)
    #v(6pt)
    - Falcon *did not* benefit from noise in the oracle setting
    - In the realistic setting, noise *does* improve Falcon — consistently across all configurations
    - Confirms that the noise benefit generalises beyond the oracle experiments

    #v(8pt)
    #finding-box[
      The practical benefit of noise is *more general* than oracle results suggested — it extends to models that previously seemed unresponsive to noise.
    ]
  ],
)
