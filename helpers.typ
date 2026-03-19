// ============================================================
//  helpers.typ  –  shared colors, callout boxes, notation tags
//  (no presentation-framework dependency)
// ============================================================

// ── Palette ──────────────────────────────────────────────────────
#let c-navy     = rgb("#16375c")
#let c-blue     = rgb("#2471a3")
#let c-lblue    = rgb("#d6eaf8")
#let c-text     = rgb("#1c2833")
#let c-muted    = rgb("#717d7e")
#let c-green    = rgb("#1a7a38")
#let c-red      = rgb("#b03a2e")
#let c-orange   = rgb("#d35400")
#let c-gold     = rgb("#9a7d0a")

// ── Document-type tags ───────────────────────────────────────────
#let _dtag(bg, border, label) = box(
  fill: bg,
  stroke: border + 0.8pt,
  radius: 3pt,
  inset: (x: 7pt, y: 3pt),
  baseline: 20%,
)[#text(fill: border, weight: "bold", size: 0.88em)[#label]]

#let tag-gold        = _dtag(c-gold.lighten(72%),   c-gold,   "G (Gold)")
#let tag-relevant    = _dtag(c-green.lighten(72%),  c-green,  "R (Relevant)")
#let tag-distracting = _dtag(c-red.lighten(72%),    c-red,    "D (Distracting)")
#let tag-random      = _dtag(c-muted.lighten(55%),  c-muted,  "N (Random/Noise)")

// ── Callout boxes ────────────────────────────────────────────────
#let info-box(body) = block(
  fill: c-lblue,
  radius: 4pt,
  inset: (x: 12pt, y: 10pt),
  width: 100%,
  stroke: (left: c-blue + 3pt),
)[#body]

#let finding-box(body) = block(
  fill: c-green.lighten(85%),
  radius: 4pt,
  inset: (x: 12pt, y: 10pt),
  width: 100%,
  stroke: (left: c-green + 3pt),
)[#body]

#let warn-box(body) = block(
  fill: c-orange.lighten(80%),
  radius: 4pt,
  inset: (x: 12pt, y: 10pt),
  width: 100%,
  stroke: (left: c-orange + 3pt),
)[#body]

#let surprise-box(body) = block(
  fill: rgb("#fdebd0"),
  radius: 4pt,
  inset: (x: 12pt, y: 10pt),
  width: 100%,
  stroke: (left: c-orange + 3pt),
)[#body]

#let key-box(body) = block(
  fill: c-navy.lighten(88%),
  radius: 4pt,
  inset: (x: 12pt, y: 10pt),
  width: 100%,
  stroke: (left: c-navy + 3pt),
)[#body]

#let navy-box(body) = block(
  fill: c-navy,
  radius: 6pt,
  inset: 14pt,
  width: 100%,
)[
  #set text(fill: white, size: 15pt)
  #align(left, body)
]

// ── Prompt notation ──────────────────────────────────────────────
// e.g.  #prompt("I", "▲", "★", "Q")
#let prompt(..parts) = box(
  fill: rgb("#f4f6f7"),
  stroke: c-muted + 0.6pt,
  radius: 3pt,
  inset: (x: 7pt, y: 4pt),
  baseline: 20%,
)[#text(font: ("Courier New", "Courier", "Monaco"), size: 0.88em)[#("[" + parts.pos().join(", ") + "]")]]

// ── Small accuracy delta helper ──────────────────────────────────
#let up(pct)   = text(fill: c-green, weight: "bold")[+#pct%]
#let down(pct) = text(fill: c-red,   weight: "bold")[−#pct%]
