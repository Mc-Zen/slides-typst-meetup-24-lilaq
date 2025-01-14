
#import "@preview/pillar:0.2.0"



#let percm = $"cm"^(-1)$
#pillar.table(
  cols: "l|CCC", 
  inset: .3em,
  [], [$B'_ν$ in #percm], [$B''_ν$ in #percm],[$D'_ν$ in #percm],
  table.hline(),
  [Measurement], [1.41], [1.47], [1.5e-5],
  [Uncertainty], [0.3], [0.3], [4e-6],
  [Ref. [2]], [1.37316], [1.43777], [5.401e-6]
)