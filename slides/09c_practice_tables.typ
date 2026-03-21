// ============================================================
//  slides/09c_practice_tables.typ  –  Detailed results tables
// ============================================================
#import "../helpers.typ": *

== Experiment 4: Detailed Results

#set text(size: 11pt)

*Table 3 - Llama2:* Wikipedia noise + retrieved docs (Contriever vs BM25)
#v(1pt)
#image("../images/table3_random_in_practise.png", width: 100%)

#v(1pt)
#text(size: 10pt, fill: c-muted)[
  Rows = random docs added, columns = retrieved docs. Bold = best per column. (\*) = not significant vs. baseline.
]

== Experiment 4: Detailed Results (Falcon)

*Table 5 - Falcon-7b:* Reddit noise + retrieved docs #prompt("I", "NNN", "D/R/G", "Q")

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
    - Tested on Reddit data (Webis-TLDR-17) as noise source
    - Most values marked (\*), meaning improvements are *statistically significant* vs. baseline
    - Best accuracy at 5 retrieved + 3 random docs: *0.2118*
    - Context window limit (2048 tokens) restricts max configurations

    #v(8pt)
    #text(size: 13pt, fill: c-muted)[
      Falcon's 2048 token context window means fewer document combinations can be tested compared to Llama2 (4096 tokens).
    ]
  ],
)
