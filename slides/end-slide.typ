#import "@preview/suiji:0.3.0"
#import "../lilaq/src/lilaq.typ" as lq


#context place(dx: -2em, dy: -3em, box(width: page.width, height: page.height, {

  let rng = suiji.gen-rng(35)
  let n = 60
  let (rng, x) = suiji.uniform(rng, low: 0, high: 10, size: n)
  let (rng, y) = suiji.uniform(rng, low: 0, high: 10, size: n)
  let (rng, colors) = suiji.uniform(rng, size: n)
  let (rng, sizes) = suiji.uniform(rng, low: 40, high: 4000, size: n)

  let data = lq.scatter(
    x, y, color: colors, size: sizes, map: (luma(20%), color.mix((purple, 40%), (blue, 60%)), luma(240)).rev(), vmin: 0, vmax: 1, clip: false,
  )
  lq.diagram(
    width: 26cm, height: 14cm,
    xlim: (0, 10), ylim: (0, 10),
    xaxis: (ticks: none, stroke: none),
    yaxis: (ticks: none, stroke: none),
    data, 
    lq.place(x: 54%, y: 41%)[Thank you]
  )
}))
