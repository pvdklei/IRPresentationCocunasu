// ============================================================
//  slides/08_finding_noise_oracle.typ  –  Noise helps (oracle)
// ============================================================
#import "../helpers.typ": *

== Experiment 3: Noise Helps (Oracle)

  #grid(
    columns: (1fr),
    gutter: 24pt,

    // ── left ──

    // ── right ──
    [
      *Not consistent across all models:*

      #v(6pt)
      - *MPT:* noise helps in _all_ positions (Near, Far, Mid)
      - *Llama2 & Phi-2:* noise helps only in the *Near* setting, but performance increase is minimal
      - *Falcon:* noise does _not_ improve accuracy

      #v(6pt)

      #finding-box[
        The benefit of noise is *model-dependent*, but Near positioning + noise is generally the best combination.
      ]

      #v(6pt)
      #text(size: 15pt)[*Best noise position:* far from query; gold near query.
      #prompt("I", "N",  "N", "N", "G", "Q") outperforms #prompt("I", "G", "N", "N", "N", "Q").]
    ],
  )
