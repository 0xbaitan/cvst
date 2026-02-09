#import "../utils/sections.typ": section-heading, section-content

/*

  Validates the input data and constructs a "Summary" section for the resume.

  Parameters:
    - `data`: A dictionary containing the summary section data.
  
  Panics:
    - If `data` is not a dictionary.
    - If `data` does not contain the key `sentences`.
    - If `data.sentences` is not an array of strings.
  
  Usage:
    Use this template to create a summary section in the resume with validated input data.
*/
#let validate-summary-section-data(data) = {
  assert(
    type(data) == dictionary,
    message: "Expected 'data' to be a dictionary."
  )
  assert(
    "sentences" in data,
    message: "Missing 'sentences' key in 'data'."
  )
  assert(
    type(data.sentences) == array,
    message: "Expected 'sentences' to be an array."
  )

 
  assert(
    data.sentences.all((sentence) => type(sentence) == str),
    message: "All items in 'sentences' must be strings."
  )
}

/* 
  Renders the Summary section of the resume.

  Parameters:
    - `data`: A dictionary containing the summary section data.

  Returns:
    - A rendered Summary section.

  Panics:
    - If the input data is invalid as per `validate-summary-section-data`.

  Usage:
    Use this function to render the Summary section in the resume.

  Example:
    #summary-section(
      {
        sentences: [
          "Experienced software developer with a passion for creating innovative solutions.",
          "Skilled in multiple programming languages and frameworks."
        ]
      }
    )
*/
#let summary-section(data) = {
   validate-summary-section-data(data)
   let summaryText = data.sentences.map(sentence => sentence.trim()).join(" ")

 
    [
      #section-heading("Summary")
      #section-content(
        [#summaryText],
        // paragraph-args: arguments(leading: 0.65em, spacing: 1.2em, justify: false),
        // text-args: arguments(),
        // spacing: 1.0em
      )
    ]
}

#summary-section(
  (
    sentences: (
      "Experienced software developer with a passion for creating innovative solutions.",
      "Skilled in multiple programming languages and frameworks."
    )
  )
)