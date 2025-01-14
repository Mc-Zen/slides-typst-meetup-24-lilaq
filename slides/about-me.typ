#import "@preview/codly:1.1.1": codly, codly-init, no-codly


== About me

#place(right + top, dy: -2.8em, grid(
  columns: 2, align: horizon, column-gutter: 1em,
  image("../resources/github logo mc-zen.png", width: 1.3cm),
  text(.7em)[_Mc-Zen_ (GitHub, Discord, Typst Forum)]
))

#v(.4em, weak: true)
// #grid(
//   columns: (1fr,)*3, align: horizon + center,
//   column-gutter: 1em,
//   row-gutter: (.4em, 2em, .8em),
//   image("resources/quill-logo.svg"),
//   image("resources/number-alignment.svg"),
//   image("resources/tidy-image.svg"),
//   [quill], [zero], [tidy],
//   image("resources/tiptoe-logo.svg"),
//   scale(50%, reflow: true)[```typ
//     #pillar.table(
//       cols: "c|ccc|r",
//       ..
//     )
//     ```],
//   [?],
//   [``tiptoe], [pillar], []

// )


#let card(name, description: none, background: none, fill: white) = box(
  fill: gradient.linear(fill.lighten(80%), fill.lighten(95%)), 
  stroke: fill.lighten(50%) + 2pt,
  inset: .6em, width: 100%, height: 100%,
  radius: 10pt,
  {
    set text(.9em, font: "Verdana")
    set par(spacing: .8em)
    set align(left + top)
    name
    block(text(.39em, description))
    background
})

#let colors = (
  blue.lighten(50%), 
  blue.lighten(50%).rotate(20deg), 
  blue.lighten(50%).rotate(40deg), 
  blue.lighten(50%).rotate(60deg), 
  blue.lighten(50%).rotate(80deg), 
  // rgb("#6A99E6"),
  rgb("#6A72E6"),
  rgb("#6AC0E6"),
  rgb("#50688F"), 
  rgb("#6AE6E4"),
  white,
  rgb("#896AE6"),
  rgb("#B6C8E6"),
  green.lighten(50%), 
  rgb("#6ae6b4").lighten(30%), 
  rgb("#4854c0").lighten(50%), 
  purple.lighten(60%), 
  white
)

#grid(
  columns: (1fr,)*3, align: horizon + center,
  rows: (5.2cm),
  column-gutter: .6em,
  row-gutter: .4em,
  card(
    "quill", 
    description: [Effortlessly create quantum circuit diagrams. ],
    background: include "../resources/quill-logo.typ",
    fill: colors.at(0)
  ),
  card(
    "zero", 
    description: [Advanced scientific number formatting and alignment. ],
    background: scale(35%, reflow: true, include "../resources/zero-alignment.typ"),
    fill: colors.at(1)
  ),
  card(
    "tidy", 
    description: [A documentation generator for package developers.],
    fill: colors.at(2)
  ),
  card(
    "tiptoe", 
    description: [Arrows and more for Typst paths.],
    background: image("../resources/tiptoe-logo.svg"),
    fill: colors.at(3)
  ),
  card(
    "pillar", 
    description: [Simplified table column specification and number alignment.],
    background: scale(70%, reflow: true, no-codly[```typ
    #pillar.table(
      cols: "c|ccc|r",
      ..
    )
    ```]),
    fill: colors.at(4)
  ),
  [?]
)
