
// ===
// Section Styles
// ===

#let default-page-settings = arguments(
  paper: "a4",
  width: 595.28pt,
  height: 841.89pt,
  flipped: false,
  margin: (
    top: 1in,
    bottom: 1in,
    left: 1in,
    right: 1in,
  ),
  columns: 1,
  fill: cmyk(0, 0, 0, 0),
  numbering: none,
  supplement: none,
  header: none,
  footer: none,
  foreground: none,
)

#let default-resume-font-settings = arguments(
  font: ("Arial", "Calibri", "Helvetica", "sans-serif", "Carlito", "Liberation Sans", "Noto Sans"),
  size: 11pt,
  color: cmyk(0, 0, 0, 100),
  weight: "regular",
  style: "normal",
  decoration: "none",
)

#let default-resume-section-settings = arguments(
  heading: (
    size: 14pt, 
    weight: bold,
    color: cmyk(0, 0, 0, 100),
    case: "uppercase",
    spacing: (
      above: 0.2em,
      below: 0.1em,
    ),
  ),
  body: (
    paragraph:
  )
)


#let section-heading-settings = arguments(
  size: 16pt,
  weight: bold,
  case: "uppercase",
  spacing: (0.1)
)