#import "@preview/quill:0.5.0": *
#quantum-circuit(
    row-spacing: 7pt,
    column-spacing: 18pt,
    wire: .6pt,
    lstick($|psi〉$), gategroup(2,4, fill:blue.lighten(80%), stroke: (thickness: .7pt, dash: "dashed")),
    gate([Quill], radius: 2pt), ctrl(1), 1, 1, meter(target: 1), [\ ],
    setwire(2), 1, phantom(content: "X"), ctrl(0), 
    1, setwire(1, stroke: (thickness: .9pt, dash: "loosely-dotted")), 15pt, 1, 
    // phantom(content: "Circuit"), 
    setwire(2, stroke: (dash: "solid", thickness: .6pt)), ctrl(0), 1, 

    annotate((3.9, 4), (0.1, 1.4), ((x0, x1), (y0, y1)) => {
      // place(line(start: (x0, y0), end: (x1, y1)))
      let x1 = x0 + 21.5pt
      place(path(((x0, y1)), ((x1, y0), (-20pt, 15pt)), stroke: .7pt))
      let xp = x0 + .14*(x1 - x0)
      let yp = y0 + .7*(y1 - y0)
      // place(path(((x0, y1)), (xp, yp), ((x1, y0), (-20pt, 15pt))))
      place(path((xp, yp), ((x1, y0), (-20pt, 15pt))))
      place(path((xp, yp), ((x1, y0), (-17pt, 15pt))))
      place(path((xp, yp), ((x1, y0), (-14pt, 19pt))))
      
    })
  )