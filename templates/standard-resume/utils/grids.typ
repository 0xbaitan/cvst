#import "@preview/oxifmt:1.0.0": strfmt

// ================================
// Grid Layout Utils
// ================================


/*
  Validates the arguments for a generic 1x2 grid-like structure.

  Parameters:
    - `cols`: An array of exactly two elements, each representing a column specification. Each element must be one of the following types or values: `auto`, `relative`,`fraction`, `length`, or `ratio`.
    - `r1c1`: The content for the first cell (row 1, column 1). Must be `none`, a `str`, or `content`.
    - `r1c2`: The content for the second cell (row 1, column 2). Must be `none`, a `str`, or `content`.

  Panics:
    - If `cols` is not an array of length 2.
    - If any element of `cols` is not of the allowed types or values.
    - If `r1c1` or `r1c2` are not of the allowed types or values.

  Usage:
    Use this function to ensure that arguments passed to a 1x2 grid utility are valid before proceeding with layout logic.
*/
#let validate-generic-1x2-grid-args(cols, r1c1, r1c2) = {
  assert.eq(type(cols), array, message: "Expected 'cols' to be an array.")
  assert.eq(cols.len(), 2, message: "Expected 'cols' to have exactly 2 elements.")

  for (i, col) in cols.enumerate() {
    assert(
      col == auto or type(col) == relative or type(col) == fraction or type(col) == length or type(col) == ratio,
      message: strfmt("Expected 'cols[{}]' to be one of the following types or values: auto, relative, fraction, length, ratio.", i)
    )
  }
  let cell-args = [r1c1, r1c2]

  for (i, cell) in cell-args.enumerate() {
    assert(
      cell == none or type(cell) == str or type(cell) == content,
      message: strfmt("Expected cell argument {} to be one of the following types or values: none, str, content.", i + 1)
    )
  }
}

/*
  A generic 1x2 grid layout util function. Renders a single row with left and right columns.

  Usage:
    #generic_1x2(
      widths: ([column 1 width], [column 2 width]),
      r1c1: [content for row 1 column 1],
      r1c2: [content for row 1 column 2],
    )

  Arguments:
    - `widths`: An array specifying the widths of the two columns. Must have exactly 2 elements. Default is `(auto, auto)`.
    - `r1c1`: Content for row 1, column 1. Default is `none`.
    - `r1c2`: Content for row 1, column 2. Default is `none`.

  Returns:
    A grid layout with the specified content and column widths.
*/
#let generic-1x2-grid(widths: (auto, auto), r1c1: none , r1c2: none ) = {

  validate-generic-1x2-grid-args(widths, r1c1, r1c2)

  grid(
    columns: widths,
    rows: auto,
    align(left)[#r1c1], align(right)[#r1c2],
  )
}

/*
  Validates the arguments for a generic 2x2 grid-like structure.

  Parameters:
    - `cols`: An array of exactly two elements, each representing a column specification. Each element must be one of the following types or values: `auto`, `relative`,`fraction`, `length`, or `ratio`.
    - `r1c1`: The content for the first cell (row 1, column 1). Must be `none`, a `str`, or `content`.
    - `r1c2`: The content for the second cell (row 1, column 2). Must be `none`, a `str`, or `content`.
    - `r2c1`: The content for the third cell (row 2, column 1). Must be `none`, a `str`, or `content`.
    - `r2c2`: The content for the fourth cell (row 2, column 2). Must be `none`, a `str`, or `content`.

  Panics:
    - If `cols` is not an array of length 2.
    - If any element of `cols` is not of the allowed types or values.
    - If any of `r1c1`, `r1c2`, `r2c1`, or `r2c2` are not of the allowed types or values.

  Usage:
    Use this function to ensure that arguments passed to a 2x2 grid utility are valid before proceeding with layout logic.
*/
#let validate-generic-2x2-grid-args(cols, r1c1, r1c2, r2c1, r2c2) = {
  assert.eq(type(cols), array, message: "Expected 'cols' to be an array.")
  assert.eq(cols.len(), 2, message: "Expected 'cols' to have exactly 2 elements.")

  for (i, col) in cols.enumerate() {
    assert(
      col == auto or type(col) == relative or type(col) == fraction or type(col) == length or type(col) == ratio,
      message: strfmt("Expected 'cols[{}]' to be one of the following types or values: auto, relative, fraction, length, ratio.", i)
    )
  }

  let cell-args = (r1c1, r1c2, r2c1, r2c2)
  for (i, cell) in cell-args.enumerate() {
    assert(
      cell == none or type(cell) == str or type(cell) == content,
      message: strfmt("Expected cell argument {} to be one of the following types or values: none, str, content.", i + 1)
    )
  }
}


/*
  A generic 2x2 grid layout util function. Renders two rows with left and right columns.

  Usage:
    #generic_2x2(
      widths: ([column 1 width], [column 2 width]),
      r1c1: [content for row 1 column 1],
      r1c2: [content for row 1 column 2],
      r2c1: [content for row 2 column 1],
      r2c2: [content for row 2 column 2],
    )

  Arguments:
    - `widths`: An array specifying the widths of the two columns. Must have exactly 2 elements. Default is `(auto, auto)`.
    - `r1c1`: Content for row 1, column 1. Default is `none`.
    - `r1c2`: Content for row 1, column 2. Default is `none`.
    - `r2c1`: Content for row 2, column 1. Default is `none`.
    - `r2c2`: Content for row 2, column 2. Default is `none`.

  Returns:
    A grid layout with the specified content and column widths.
*/  
#let generic-2x2-grid(widths: (auto, auto), r1c1: none , r1c2: none , r2c1: none , r2c2: none ) = {

  validate-generic-2x2-grid-args(widths, r1c1, r1c2, r2c1, r2c2)

  grid(
    columns: widths,
    rows: auto,
    align(left)[#r1c1], align(right)[#r1c2],
    align(left)[#r2c1], align(right)[#r2c2],
    gutter: 0.55em
  )
}



#let resume-section(section-title, resume-section-settings, body: []) = {
  set par(leading: v-space-medium)
  set heading(numbering: none, outlined: true, level: 1)
  [= #section-title]
  body
}
