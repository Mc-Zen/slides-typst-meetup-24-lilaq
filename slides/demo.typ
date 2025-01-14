#import "../lilaq/src/lilaq.typ" as lq
#import "@preview/suiji:0.3.0"

#set page(margin: (top: 28pt, rest: 33pt), background: 
  box(
    width: 100%, height: 100%, 
    fill: rgb("#e6e6e6"), inset: 14pt, 
    box(
      width: 100%, height: 100%, 
      fill: white, 
      stroke: 1pt + rgb("#b7b7b7"), radius: 10pt
    )
  )
)

#set text(size: .25em, black, weight: "regular")

#let koch-snowflake(n) = {
  let complex-add(c1, c2) = { c1.zip(c2).map(array.sum) }
  let complex-multiply(c1, c2) = (c1.at(0) * c2.at(0) - c1.at(1) * c2.at(1), c1.at(0) * c2.at(1) + c1.at(1) * c2.at(0))
  let complex-inverse-array(a) = { a.map(c => c.map(x => -x)) }
  let complex-multiply-array(a, c) = { a.map(c1 => complex-multiply(c1, c)) }
  let complex-add-array(a1, a2) = { a1.zip(a2).map(cs => complex-add(..cs)) }
  
  let koch-snowflake-impl(n) = {
    if n == 0 {
      return (90deg, 210deg, 330deg).map(phi => (calc.cos(phi), calc.sin(phi)))
    }
    let ps1 = koch-snowflake-impl(n - 1)
    let diff = complex-add-array(ps1.slice(1) + (ps1.first(),), complex-inverse-array(ps1))
    let points = (
      ps1,
      complex-add-array(ps1, complex-multiply-array(diff, (1/3, 0))),
      complex-add-array(ps1, complex-multiply-array(diff, (0.5, -.5 * calc.sqrt(3) / 3))),
      complex-add-array(ps1, complex-multiply-array(diff, (2/3, 0))),
    )
    return array.zip(..points).join()
  }
  return koch-snowflake-impl(n)
}



#let koch = lq.diagram(
  width: 4cm, 
  height: 4cm,
  xlim: (-1, 1), 
  ylim: (-1, 1), 
  lq.path(
    ..koch-snowflake(4), 
    closed: true, fill: blue
  )
)


#let scatter = {

  let rng = suiji.gen-rng(33)
  let (rng, x) = suiji.uniform(rng, low: 0, high: 10, size: 20)
  let (rng, y) = suiji.uniform(rng, low: 0, high: 10, size: 20)
  let (rng, colors) = suiji.uniform(rng, size: 20)
  let (rng, sizes) = suiji.uniform(rng, low: 20, high: 400, size: 20)

  let plot = lq.scatter(
    x, y, 
    color: colors, 
    size: sizes, 
    map: (luma(20%), color.mix((purple, 40%), (blue, 60%)), luma(240)).rev(), 
    vmin: 0, vmax: 1,
  )

  lq.diagram(
    width: 5cm,
    xlim: (0, 10), 
    ylim: (0, 10),
    plot, 
  )
  h(2mm)
  lq.colorbar(plot)
}

#let magma-mesh = {
  let plot = lq.colormesh(
    lq.linspace(-4, 4, num: 10), 
    lq.linspace(-4, 4, num: 10),
    (x, y) => x*y, 
    map: color.map.magma
  )

  lq.diagram(
    width: 4cm,
    plot,
  )
  h(.3cm)
  lq.colorbar(plot)
}


#let magma-contour = {
  let plot = lq.contour(
    lq.linspace(-4, 4, num: 10),
    lq.linspace(-4, 4, num: 10),
    (x, y) => x*y, 
    map: color.map.icefire, 
    fill: true
  )

  lq.diagram(
    width: 4cm,
    plot,
  )
  h(.3cm)
  lq.colorbar(plot)
}

#let quiver = {

  lq.diagram(
    lq.quiver(
      lq.linspace(-4, 4, num: 6),
      lq.linspace(-4, 4, num: 6),
      (x, y) => (x + y, y - x), 
      scale: .17
    ),
  )

}

#let mesh = lq.mesh(
    lq.linspace(-3, 3, num: 40),
    lq.linspace(-3, 3, num: 40),
    (x, y) => (1 - x/2 + calc.pow(x, 5) + calc.pow(y, 3)) * calc.exp(-x*x - y*y)
)
#let minmax(mesh) = {
  let z = mesh.at(2).flatten()
  (calc.min(..z), calc.max(..z))
}
#let (zmin, zmax) = minmax(mesh)
#let filled-contour = lq.diagram(
  lq.contour(..mesh, fill:true, levels: lq.linspace(zmin, zmax, num: 7))
)
#let contour = lq.diagram(
  lq.contour(..mesh, levels: lq.linspace(zmin, zmax, num: 7))
)

#let axes = lq.diagram(
  xscale: lq.scale.log(base: 2),
  width: 4cm, 
  xlim: (2.5, 420),
  ylim: (-1, 1),
  xaxis: (position: 0),
  lq.yaxis(
    position: (right, 20pt), 
    functions: (x => 2*x, y => 0.5*y)
  ),
  lq.yaxis(
    position: (right, 50pt), 
    scale: "log", 
    functions: (x => calc.exp(x), y => calc.ln(y))
  ),
  lq.yaxis(
    position: (right, 80pt), 
    scale: "linear", 
    functions: (x => (x+1)*(x+1), y => calc.sqrt(y)-1 )
  ),
)

#grid(
  columns: (1fr,) * 4, 
  align: left + top,
  row-gutter: 20pt, 
  scatter, quiver, magma-mesh, magma-contour, contour, filled-contour, koch, move(dx: -3em, axes)
)

#v(4mm)
#include "tiny-previews.typ"
#box(stroke: gray, width: 40%, inset: 1pt, radius: 10pt, fill: luma(97.25%), {
  include "logo.typ"
})
