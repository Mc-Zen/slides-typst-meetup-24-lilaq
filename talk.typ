
#import "theme.typ": *
#import "lilaq/src/lilaq.typ" as lq

#let date = datetime(year: 2024, day: 14, month: 12)

#set document(
  author: "Kyano Levi",
  title: "A picture is worth a thousand words − Talk at the Typst Meetup 2024",
  date: date,
  keywords: ("visualization", "typst", "plotting")
)
#set raw(lang: "typc")


#show: my-theme.with(
  aspect-ratio: "16-9",
  primary: rgb("#6652ad"),
  config-info(
    title: [A picture is worth a thousand words],
    subtitle: [Data visualization with Typst: Lilaq],
    author: "Kyano Levi",
    date: date,
  ),
)



#title-slide()



#include "slides/about-me.typ"



#focus-slide(background-img: image("resources/lilac-background.jpg"))[
  // image from https://www.freeimages.com/photo/lilac-1375284
  #box(
    fill: black.transparentize(75%), 
    inset: .5em, radius: .22em,
    [A vision]
  )
]



#focus-slide(background-color: white)[
  #include "slides/demo.typ"
]



== Data visualization matters

#align(center, {
  set text(.8em)
  let (date, count, _) = lq.load-txt(
    skip-rows: 1,
    read("resources/arxiv_monthly_submissions.csv"),
    converters: ("0": x => x, "1": int)
  )

  let datelabel(x) = {
    rotate(-30deg, x.trim("-09"), reflow: true)
  }

  lq.diagram(
    title: [Monthly publications on arXiv #text(gray)[(source: arXiv)]],
    height: 7.4cm, width: 18cm,
    yaxis: (exponent: 0),
    xaxis: (
      tick-distance: 12*4, 
      format-ticks: (info, ..) => {
        (info.ticks.map(i => datelabel(date.at(int(i)))), 0, 0)
      }),
    lq.plot(range(count.len()), count)
  )
})



#pagebreak()

#v(2cm)
- Goal: publication-ready graphics, diagrams, plots, ...

- Streamlined workflow




#focus-slide[
  Where are we?
]



== Popular Graphics Tools

- Most common tools for technical papers
#grid(
  columns: 2, inset: .8em, 
  [
    *Matplotlib*
    #show: pros
    - UX
    - Speed (usually)
    #show: cons
    - Bad integration with document
  ],
  grid.vline(),
  [
    *PGFplots* (TikZ)
    #show: pros
    - Good integration with document (LaTeX)
    - Uniform styling
    #show: cons
    - Slow
    - Hard to learn/use
  ], 
)


#focus-slide[
  What do we want?

  #pause
  #set text(.8em)
  #place(center + horizon, dy: 2em)[_All of it!_]
]



== Typst for data visualization

- Pros:
#[
  #show: pros
  - *Quick* preview -- faster design iterations

  - *Customization* through `set` rules

  - *Composability* and more *customization* through `show` rules
]
- Cons:
#[
  #show: cons
  - Name it!
]



== Lilaq

#grid(columns: 2, column-gutter: .5em, align: horizon,
  [
    ```typ
    #let xs = lq.linspace(0, 5, num: 40)
    #let ys1 = xs.map(x => calc.sin(x))
    #let ys2 = xs.map(x => calc.cos(x))

    #lq.diagram(
      title: [Trigonometric functions],
      xlabel: $x$,
      ylabel: $y$,
      lq.plot(xs, ys1, color: red, label: $sin(x)$),
      lq.plot(xs, ys2, marker: "star", label: $cos(x)$),
    )
    ```
  ],
  scale(reflow: true, 140%)[
    #set text(.5em)
    #let xs = lq.linspace(0, 5, num: 40)
    #let ys1 = xs.map(x => calc.sin(x))
    #let ys2 = xs.map(x => calc.cos(x))

    #lq.diagram(
      title: [Trigonometric functions],
      xlabel: $x$,
      ylabel: $y$,
      lq.plot(xs, ys1, color: red, label: $sin(x)$),
      lq.plot(xs, ys2, mark: "star", label: $cos(x)$),
    )
])



== Let's dream

#place(right, box(width: 45%, 

  {
    show "#type": text.with(red)
    show "field": text.with(red)
    ```typc
    #type diagram {
      field width = 7cm
      field height = 5cm
      field legend = true
      field xlim = auto
      field ylim = auto
      field margin = 5%
      ...
      field children

      show: it => ...
    }
    ```
  }
))

#grid(
  columns: (1fr, 1fr), column-gutter: 1em,
  [
    - User-defined types
    #pause
    #grid(columns: (1fr), align: center + horizon, row-gutter: 1em,
      image("resources/waiting-for-types.png"),
      [#sym.arrow.t #emoji.face.sad ]
    )
  ],[
  ]
)


== 1. Composition of features

#slide(repeat: 3, self => [
  #let (uncover, only, alternatives) = utils.methods(self)

  #grid(columns: (auto, 1fr), column-gutter: 2em, align: horizon, 
  rows: 10cm,
    {
      set text(.5em)
      lq.diagram(
        width: 9cm, height: 6cm,
        xlabel: $x$,
        ylabel: $y$,
        title: [Title],
        lq.plot((1,2,3,4,5,6), (1,3,2.5,3.3,2,1.6), label: [Data])
      )
    }, 
    alternatives(position: horizon)[][
      #show: cons
      - All elements need their own\ text settings. 
      ```py
      ax.set_xlabel('$x$', fontsize=10)
      ax.set_ylabel('$y$', fontsize=10)
      ax.set_title('Title', fontsize=12)
      ...
      ```
    ][
      #show: pros
      - The elements don't need to \ know about text! 
      ```typ
      #show xlabel: set text(10pt)
      #show ylabel: set text(10pt)
      #show title: set text(12pt)
      ...
      ```
    ],
  )
])



== 2. Composition of features -- cross-package

#slide(repeat: 2, self => [
  #let (uncover, only, alternatives) = utils.methods(self)

  #place[]
  #grid(columns: (1.1fr, 1fr), column-gutter: 1em, align: (top, bottom), inset: (0em, 1em), rows: 11.2cm,
    [
      - Number formatting handled by another package: _zero_

      - Designed for interoperability with Lilaq

      #only("2")[
        - Global configuration also \ affects plots ~#check
      ]
    ],
    grid.vline(),
    alternatives[
      #set text(.8em, red)
      #lq.diagram(
        width: 9cm, height: 4.7cm,
        ylim: (0, 100000)
      )
    ][
      ```typ
      #set zero.num(
        product: sym.dot,
        decimal-separator: ","
      )
      ```
      #v(.6cm)
      #import "@preview/zero:0.3.0": set-num, num
      #set-num(product: sym.dot + sym.space.thin, decimal-separator: ",", tight: false)
      #set text(.8em, red)
      #lq.diagram(
        width: 9cm, height: 4.7cm,
        ylim: (0, 100000)
      )
      #set-num(product: sym.times, decimal-separator: ".")

    ]
  )
])


== 3. Presets

- Presets are just `show` rules. 
```typ
#let my-preset = body => {
  show diagram: set text(.8em)
  set lq.tick(outside: 3pt, inside: 0pt)
  set lq.subtick(outside: 1.5pt, inside: 0pt)
  set lq.legend(fill: white.transparentize(50%))

  show lq.xlabel: set align(right)
  show lq.ylabel: set align(top)
  body
}
```
#pagebreak()

```typ
#{
  // Use the preset locally
  show: my-preset
  
  lq.diagram(
    ..
  )
}
```


== When can we use it?

- I'd like to avoid rewriting all of it 

  #sym.arrow.r First need user-defined types (for `set` and `show` rules)

- For an early (free) copy, get in touch with me

- Contributors welcome!


==
#include "slides/end-slide.typ"
