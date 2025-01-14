// Theme created by Mc-Zen and used for the presentation on lilaq
// It is based on the touying theme university, originally by Pol Dellaiera (https://github.com/drupol)

#import "@preview/touying:0.5.3": *
#import "@preview/codly:1.1.1": codly, codly-init, no-codly
#import "@preview/codly-languages:0.1.3": codly-languages
#import "@preview/tiptoe:0.1.0"

#let spine = 3pt + luma(80%)

/// Default slide function for the presentation.
///
/// - `config` is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
/// - `repeat` is the number of subslides. Default is `auto`，which means touying will automatically calculate the number of subslides.
///   The `repeat` argument is necessary when you use `#slide(repeat: 3, self => [ .. ])` style code to create a slide. The callback-style `uncover` and `only` cannot be detected by touying automatically.
/// - `setting` is the setting of the slide. You can use it to add some set/show rules for the slide.
/// - `composer` is the composer of the slide. You can use it to set the layout of the slide.
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts. The first and the last parts will take 1/4 of the slide, and the second part will take 1/2 of the slide.
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`, it will be assumed to be the first argument of the `components.side-by-side` function.
///   The `components.side-by-side` function is a simple wrapper of the `grid` function. It means you can use the `grid.cell(colspan: 2, ..)` to make the cell take 2 columns.
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]]` will make the `Footer` cell take 2 columns.
///   If you want to customize the composer, you can pass a function to the `composer` argument. The function should receive the contents of the slide and return the content of the slide, like `#slide(composer: grid.with(columns: 2))[A][B]`.
/// - `..bodies` is the contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = align(top, block(
      inset: (x: 3em, y: 2em),
      text(fill: self.colors.primary, weight: "bold", size: 1em, 
        utils.call-or-display(self, self.store.header)
      )
    )
  )
  let footer(self) = context {
    set text(size: .5em)

    let clr = self.colors.primary.lighten(13%)
    let num-slides = utils.last-slide-counter.final().first()
    let slide = utils.slide-counter.get().first()
    let available-width = page.width - 4em

    let pad = 2em

    // Coordinate axes
    place(bottom, dx: pad,
      tiptoe.line(length: page.height - pad, angle: -90deg, stroke: spine, tip: tiptoe.stealth.with(inset: 10%, length: 600%))
    )
    place(bottom, dy: -pad,
      tiptoe.line(length: page.width - pad, stroke: spine, tip: tiptoe.stealth.with(inset: 10%, length: 600%))
    )

    let closed-circle = circle(fill: clr, radius: .3em, stroke: clr + 1pt)
    // Origin
    place(bottom, dx: pad, dy: -pad, place(center + horizon, closed-circle))

    // x ticks and labels
    for i in range(1, num-slides) {
      let dx = pad + available-width / (num-slides) * i
      let stroke = spine
      if slide >= i {
        stroke = stroke.thickness + clr
      }
      place(
        bottom,
        dy: -pad,
        dx: dx, 
        line(angle: 90deg, length: 1em, stroke: stroke)
      )
      if slide == i {
        place(bottom, dy: -pad, dx: pad,
          line(length: dx - pad, stroke: stroke)
        )
        place(bottom, dx: dx, dy: -pad, place(center + horizon, circle(stroke: stroke.paint + 2pt, fill: white, radius: .3em)))
      }
      if slide < i { continue }
      place(
        bottom,
        dy: -pad/2 - .3em,
        dx: dx, 
        place(center, text(1.1em, spine.paint, weight: "bold")[#i])
      )
    }
    if slide == num-slides {
      let dx = pad + available-width / num-slides * (num-slides - 1)
      let stroke = spine.thickness + clr
      place(bottom, dy: -pad, dx: pad,
        line(length: dx - pad, stroke: stroke)
      )
      place(bottom, dx: dx, dy: -pad, place(center + horizon, closed-circle))
    }
  }

  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
      margin: (x: 3em, top: 4.4em), 
    ),
  )
  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})



/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// ```example
/// #show: my-theme.with(
///   config-info(
///     title: [Title],
///     logo: emoji.school,
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle])
/// ```
#let title-slide(
  /// Extra information of the slide. You can pass the extra information to the `title-slide` function.
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  let body = {
    if info.logo != none {
      place(right, text(fill: self.colors.primary, info.logo))
    }
    v(2.8cm)
    text(size: 1.4em, fill: self.colors.primary, strong(info.title))
    if info.subtitle != none {
      parbreak()
      text(size: 1.1em, fill: self.colors.primary, info.subtitle, style: "italic")
    }
    v(3.75cm)
    set text(size: .8em, fill: rgb("#293133"))
    info.authors.map(author => text(author)).join()
    if info.institution != none {
      parbreak()
      text(size: .9em, info.institution)
    }
    if info.date != none {
      h(1fr)
      self.info.date.display("[month repr:long] [day], [year]")
    }
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      background: {
        image("resources/lilac-background.jpg", fit: "cover", width: 100%)
        place(dy: -100%, rect(width: 100%, height: 100%, fill: white.transparentize(10%)))
      }
      // background: {
      //   import "@preview/suiji:0.3.0"
      //   let rng = suiji.gen-rng(32)
      //   let cols = 24
      //   let rows = 15
      //   let (rng, shades) = suiji.random(rng, size: cols * rows)

      //   let color = self.colors.primary
      //   grid(
      //     columns: (1fr,) * cols,
      //     rows: (1fr,) * rows,
      //     fill: (x, y) => {
      //       let i = x + y*20 
      //       color.transparentize(100% - calc.pow(shades.at(i),6) * 17%)
      //     }

      //   )
      // }
    ),
  )
  touying-slide(self: self, body)
})


/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - `level` is the level of the heading.
/// - `numbered` is whether the heading is numbered.
/// - `body` is the body of the section. It will be pass by touying automatically.
#let new-section-slide(level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  let slide-body = {
    set align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em, fill: self.colors.primary, weight: "light")
    stack(
      dir: ttb,
      spacing: .65em,
      utils.display-current-heading(level: level, numbered: numbered),
      block(
        height: 2pt,
        width: 100%,
        spacing: 0pt,
        components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light),
      ),
    )
    body
  }
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lightest),
  )
  touying-slide(self: self, slide-body)
})


/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - `background-color` is the background color of the slide. Default is the primary color.
/// - `background-img` is the background image of the slide. Default is none.
#let focus-slide(background-color: none, background-img: none, body) = touying-slide-wrapper(self => {
  let background-color = if background-img == none and background-color == none {
    rgb(self.colors.primary)
  } else {
    background-color
  }
  let args = (:)
  if background-color != none {
    args.fill = rgb(background-color).desaturate(10%)
  }
  if background-img != none {
    args.background = {
      set image(fit: "cover", width: 100%, height: 100%)
      background-img
    }
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 1em, ..args),
  )
  set align(center)
  set text(fill: self.colors.neutral-lightest, weight: "bold", size: 1.8em)
  touying-slide(self: self, align(horizon, body))
})


// Create a slide where the provided content blocks are displayed in a grid and coloured in a checkerboard pattern without further decoration. You can configure the grid using the rows and `columns` keyword arguments (both default to none). It is determined in the following way:
///
/// - If `columns` is an integer, create that many columns of width `1fr`.
/// - If `columns` is `none`, create as many columns of width `1fr` as there are content blocks.
/// - Otherwise assume that `columns` is an array of widths already, use that.
/// - If `rows` is an integer, create that many rows of height `1fr`.
/// - If `rows` is `none`, create that many rows of height `1fr` as are needed given the number of co/ -ntent blocks and columns.
/// - Otherwise assume that `rows` is an array of heights already, use that.
/// - Check that there are enough rows and columns to fit in all the content blocks.
///
/// That means that `#matrix-slide[...][...]` stacks horizontally and `#matrix-slide(columns: 1)[...][...]` stacks vertically.
#let matrix-slide(columns: none, rows: none, ..bodies) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em),
  )
  touying-slide(self: self, composer: components.checkerboard.with(columns: columns, rows: rows), ..bodies)
})




/// Touying my theme.
///
/// Example:
///
/// ```example
/// #show: my-theme.with(aspect-ratio: "16-9", config-colors(primary: blue))`
/// ```
///
/// - `aspect-ratio` is the aspect ratio of the slides. Default is `16-9`.
/// - `progress-bar` is whether to show the progress bar. Default is `true`.
/// - `header` is the header of the slides. Default is `utils.display-current-heading(level: 2)`.
/// - `header-right` is the right part of the header. Default is `self.info.logo`.
/// - `footer-columns` is the columns of the footer. Default is `(25%, 1fr, 25%)`.
/// - `footer-a` is the left part of the footer. Default is `self.info.author`.
/// - `footer-b` is the middle part of the footer. Default is `self.info.short-title` or `self.info.title`.
/// - `footer-c` is the right part of the footer. Default is `self => h(1fr) + utils.display-info-date(self) + h(1fr) + context utils.slide-counter.display() + " / " + utils.last-slide-number + h(1fr)`.
///
/// ----------------------------------------
///
/// The default colors:
///
/// ```typ
/// config-colors(
///   primary: rgb("#04364A"),
///   secondary: rgb("#176B87"),
///   tertiary: rgb("#448C95"),
///   neutral-lightest: rgb("#ffffff"),
///   neutral-darkest: rgb("#000000"),
/// )
/// ```
#let my-theme(
  aspect-ratio: "16-9",
  progress-bar: true,
  header: utils.display-current-heading(level: 2),
  header-right: self => utils.display-current-heading(level: 1) + h(.3em) + self.info.logo,
  footer-columns: (25%, 1fr, 25%),
  footer-a: self => self.info.author,
  footer-b: self => if self.info.short-title == auto {
    self.info.title
  } else {
    self.info.short-title
  },
  footer-c: self => {
    h(1fr)
    utils.display-info-date(self)
    h(1fr)
    context utils.slide-counter.display() + " / " + utils.last-slide-number
    h(1fr)
  },
  primary: black,
  ..args,
  body,
) = {
  let clr = color.mix((purple, 40%), (blue, 60%))
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      header-ascent: 0em,
      footer-descent: 0em,
      margin: (top: 2em, bottom: 1.25em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      show-strong-with-alert: false,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(fill: self.colors.neutral-darkest, size: 25pt)
        show heading: set text(fill: self.colors.primary)
  
        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: primary,
      secondary: color.mix((purple, 40%), (blue, 60%)).darken(60%),
      tertiary: rgb("#448C95"),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#293133"),
    ),
    config-store(
      progress-bar: progress-bar,
      header: header,
      header-right: header-right,
      footer-columns: footer-columns,
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
    ),
    ..args,
  )
  
  set list(
    spacing: 2.3em, indent: -2em,
    marker: {
      place(top, dy: .4em, line(stroke: spine, length: .5em))
      h(1.5em)
    }
  )
  show: codly-init
  codly(number-format: none, languages: codly-languages)
  show raw.where(block: true): set text(.695em)

  show link: underline
  show link: text.with(blue)
  set text(23pt, font: "Verdana")

  body
}



#let check = box(
    width: 14pt, 
    height: 12pt, 
    path(stroke: (paint: green, thickness: 3pt, cap: "round", join: "round"), (0%, 60%), (30%, 110%), (100%, 10%))
)

/// Activate "pros" list style with green checks as list markers. 
/// ```example
/// #show: pros
/// ```
#let pros(it) = {
  set list(spacing: auto, indent: 0pt, marker: check)
  it
}


/// Activate "cons" list style with red crosses as list markers. 
/// ```example
/// #show: cons
/// ```
#let cons(it) = {
  set list(spacing: auto, indent: 0pt, marker: box(
    width: 12pt, 
    height: 12pt, {
      set line(stroke: (paint: red, thickness: 3pt, cap: "round", join: "round"))
      place(line(start: (0%, 10%), end: (100%, 110%)))
      place(line(start: (100%, 10%), end: (0%, 110%)))
    }
  ))
  it
}

