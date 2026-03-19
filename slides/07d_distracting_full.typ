// ============================================================
//  slides/07d_distracting_full.typ  –  Full results table
// ============================================================
#import "../helpers.typ": *

== Distracting Documents — Results

#image("../images/table1_results_distracting.png", width: 100%)

#v(4pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,

  [
    #set text(size: 13pt)
    - Progressive degradation across *all LLMs* — accuracy drops up to 67%
    - Even *one* distracting document causes up to 25% accuracy loss
    - Consistent across all three positions (far, mid, near)
  ],

  [
    #set text(size: 13pt)
    - Confirmed with *ADORE* (hard-negative retriever) — same degradation
    - Distinguishing relevant from distracting is a hard problem that *cannot be mitigated* by changing the retrieval method
  ],
)
