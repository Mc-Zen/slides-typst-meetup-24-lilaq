#import "../lilaq/src/lilaq.typ" as lq
#import "@preview/suiji:0.3.0"


#let p = {
  let color = color.mix((purple, 40%), (blue, 60%))
  
  let diagram = lq.diagram.with(
    width: 2cm, height: 2cm,
    xaxis: (ticks: none, stroke: .7pt + gray), 
    yaxis: (ticks: none, stroke: .7pt + gray), 
  )

  let x = lq.linspace(0.1, .6, num: 8)
  diagram(
    lq.plot(x, x.map(x => x*x), color: color),
    lq.plot(x, x, stroke: none, color: color),
    lq.plot(x, x.map(x => calc.sqrt(x)), mark: none, color: color),
  )

  

  diagram(
    margin: 20%,
    lq.plot((1, 2, 3), (4, 3.5, 5), yerr: (.6, .4, .7), color: color, mark-size: 8pt)
  )
  

  diagram(
    margin: 20%,
    lq.plot(step: start, (1, 2, 3, 4), (4, 3.5, 5, 4.5),  color: color, mark-size: 8pt)
  )
  

  let rng = suiji.gen-rng(16)
  let (rng, x) = suiji.uniform(rng, low: 0, high: 10, size: 10)
  let (rng, y) = suiji.uniform(rng, low: 0, high: 10, size: 10)
  let (rng, colors) = suiji.uniform(rng, size: 10)
  let (rng, sizes) = suiji.uniform(rng, low: 10, high: 400, size: 10)
  
  diagram(
    margin: 20%,
    lq.scatter(x, y, color: colors, size: sizes, map: (color, luma(240)))
  )

  
  

  let x = lq.linspace(0, 3, num: 25)
  let y1 = x.map(x => calc.sin(x))
  let y2 = x.map(x => calc.cos(x))
  diagram(
    lq.fill-between(x, y1, y2: y2, fill: color.lighten(40%), stroke: color),
  )

  

  let x = lq.arange(-4, 5)
  let y = x.map(x => calc.exp(-x*x/6))
  diagram(
    lq.bar(x, y, fill: color),
  )

  

  let x = lq.arange(-4, 5)
  let y = x.map(x => calc.exp(-x*x/6))
  diagram(
    margin: 10%,
    lq.stem(x, y, color: color, base-stroke: none),
  )

  
  
  let rng = suiji.gen-rng(16)
  let (rng, x1) = suiji.uniform(rng, low: 0, high: 10, size: 10)
  let (rng, x2) = suiji.uniform(rng, low: 0, high: 10, size: 10)
  diagram(
    lq.boxplot((x1, x2), stroke: color, median: black),
  )
  
  


  let x = lq.linspace(-1., 3, num: 12)
  let y = lq.linspace(-1., 3, num: 12)
  let mesh = lq.mesh(x, y, (x, y) => calc.pow(calc.sin(x) * calc.cos(.2*x+y), 3)).at(2)
  diagram(
    lq.colormesh(x, y, mesh, map: (color, luma(240))),
  )
  
  diagram(
    lq.contour(x, y, mesh, fill: true, map: (color, luma(240))),
  )
  
  diagram(
    lq.contour(x, y, mesh, map: (color, luma(240))),
  )

  
    
  
  let (x, y, directions) = lq.mesh(
    lq.linspace(-4, 4, num: 6),
    lq.linspace(-4, 4, num: 6),
    (x, y) => (x, x*y),
  )
  let colors = lq.mesh(x, y, (u,v) => calc.sqrt(u*u+v*v)).at(2)
  
  diagram(
    lq.quiver(x, y, directions, scale: 7, color: colors, map: (luma(240), color))
  )

  
}

#box(width: 60%, grid(
  columns: (auto,)*6,
  row-gutter: 4pt,
  column-gutter: 4pt, ..p.children
))