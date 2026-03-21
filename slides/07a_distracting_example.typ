// ============================================================
//  slides/07a_distracting_example.typ  –  Example + question
// ============================================================
#import "../helpers.typ": *

== Experiment 2: Distraction Example

#set text(size: 14pt)

#align(center)[
  #text(size: 17pt)[
    #block(
      fill: rgb("#f4f6f7"),
      stroke: c-muted + 0.5pt,
      radius: 4pt,
      inset: (x: 14pt, y: 10pt),
    )[
      *Query:* _"Who owned the Millennium Falcon before Han Solo?"_
    ]
  ]
]

#v(12pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,

  [
    #tag-distracting *Doc 1:*
    #block(
      fill: c-red.lighten(90%),
      stroke: c-red + 0.5pt,
      radius: 4pt,
      inset: (x: 8pt, y: 6pt),
    )[
      Before the events of the film, he and Chewbacca had lost the "Millennium Falcon" to thieves, but they reclaim the ship after it...
    ]
  ],

  [
    #tag-distracting *Doc 2:*
    #block(
      fill: c-red.lighten(90%),
      stroke: c-red + 0.5pt,
      radius: 4pt,
      inset: (x: 8pt, y: 6pt),
    )[
      The "Falcon" has been depicted many times in the franchise, and ownership has changed several times...
    ]
  ],

  [
    #tag-gold *Doc 3:*
    #block(
      fill: c-gold.lighten(85%),
      stroke: c-gold + 0.5pt,
      radius: 4pt,
      inset: (x: 8pt, y: 6pt),
    )[
      Han Solo won the Millennium Falcon from *Lando Calrissian* in the card game sabacc...
    ]
  ],
)

#v(12pt)

#align(center)[
  #text(size: 17pt)[
    #block(
      fill: c-red.lighten(90%),
      stroke: c-red + 0.5pt,
      radius: 4pt,
      inset: (x: 14pt, y: 10pt),
    )[
      *Answer:* #text(fill: c-red, weight: "bold")[Han Solo] #h(6pt) #text(fill: c-muted)[(correct: Lando Calrissian)]
    ]
  ]
]
