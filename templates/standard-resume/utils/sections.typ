// ================================
// Section Utils
// ================================

/*
  Validates the arguments for a section heading.

  Parameters:
    - `text`: The heading text. Must be of type `str` or `content`.
    - `font`: The font for the heading. (Not validated here)
    - `size`: The font size for the heading. Must be of type `length`.
    - `weight`: The font weight for the heading. Must be a valid font weight string or number.
    - `case`: The text case transformation for the heading. Must be one of `"uppercase"`, `"lowercase"`, `"capitalize"`, or `"normal"`.
    - `spacing`: The spacing around the heading. Must be of type `length` or a dictionary with `above` and `below` length values.
    - `color`: The color for the heading. Must be of type `color`.

  Panics:
    - If any of the parameters do not meet the specified type or value requirements.

  Usage:
    Use this function to ensure that arguments passed to a section heading utility are valid before proceeding with rendering logic.
*/
#let validate-section-heading-args(text-content) = {
  assert(
    type(text-content) == str or type(text-content) == content,
    message: "Section heading 'text-content' must be of type 'str' or 'content'."
  )
}




/* 
  Renders a section heading with specified text and styles.

  Parameters:
    - `text`: The heading text to display. Must be of type `str` or `content`.
    - `size`: The font size for the heading. Default is `16pt`.
    - `weight`: The font weight for the heading. Default is `bold`.
    - `case`: The text case transformation for the heading. Default is `"uppercase"`.
    - `spacings`: A dictionary specifying spacing above and below the heading. Default is `(above: 0.1em, below: 0.1em)`.

  Returns:
    A styled section heading.

  Usage:
    Use this function to create consistent section headings throughout the resume.
*/
#let section-heading(
  text-content,
  case: "smallcaps",
  spacings: (above: 0.4em, between-header-and-line: 0.2em, below: 0.4em),
  heading-args: arguments(),
  paragraph-args: arguments(),
  text-args: arguments(),
  line-args: arguments(),
) = {
  validate-section-heading-args(text-content)

  set heading(
    level: 1,
    depth: 1,
    numbering: none,
    outlined: true,
    supplement: none,
    ..heading-args
  )

  set par(
    leading: 0.65em,
    spacing: 0.55em,
    justify: false,
    ..paragraph-args
  )

  set text(
    font: "Carlito",
    size: 1.1em,
    weight: "bold",
    fallback: true,
    fill: color.navy,
    ..text-args
  )

  set line(
    length: 100%,
    stroke: stroke(thickness: 0.4pt),
    ..line-args
  )

  let heading-body = if case == "smallcaps" {
    smallcaps(text-content)
  } else if case == "uppercase" {
    upper(text-content)
  } else if case == "lowercase" {
    lower(text-content)
  } else {
    text-content
  }

  [
    #v(spacings.above)
    = #heading-body
    #v(spacings.between-header-and-line)
    #line()
    #v(spacings.below)
  ]
}

// ================================

#let validate-section-content-args(section-content, paragraph-args, text-args, spacing) = {
  assert(
    type(section-content) == content,
    message: "Section content must be of type 'content'."
  )

  assert(
    type(paragraph-args) == arguments,
    message: "Paragraph arguments must be of type 'arguments'."
  )

  assert(
    type(text-args) == arguments,
    message: "Text arguments must be of type 'arguments'."
  )

  assert(
    type(spacing) == dictionary and "above" in spacing and "below" in spacing and type(spacing.above) == length and type(spacing.below) == length,
    message: "Spacing must be a dictionary with 'above' and 'below' length values."
  )
}


#let section-content(
  section-content,
  paragraph-args: arguments(
  ),
  text-args: arguments(
  ),
  list-args: arguments(),
  spacing: (above: -0.5em, below: -0.5em)
) = {

  validate-section-content-args(section-content, paragraph-args, text-args, spacing)

  
  set par(
     leading: 0.55em,
     spacing: 1.5em,
     justify: false,
     first-line-indent: 0em,
    ..paragraph-args)


  set text(
    font: "Carlito",
    size: 1em,
    weight: "regular",
    fallback: true,
    fill: color.black,
    ..text-args)

  set list(
    indent: 0.55em,
    spacing: 1em,
    ..list-args)

  [
    #v(spacing.above)
    #section-content
    #v(spacing.below)
  ]
}


// ================================
