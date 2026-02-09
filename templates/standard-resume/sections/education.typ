#import "../utils/sections.typ": section-content, section-heading
#import "../utils/dates.typ": date-range-content, validate-date-dictionary
#import "../utils/grids.typ": generic-2x2-grid

/*
  Validates the arguments for the education item.

  Parameters:
    - `institution`: The name of the educational institution.
    - `degree`: The degree obtained.
    - `location`: The location of the institution.
    - `award`: Any awards received.
    - `start-date`: The start date of the education period.
    - `end-date`: The end date of the education period.
    - `activities`: A list of activities or achievements.

  Panics:
    - If any of the required arguments are missing or of incorrect type.

  Usage:
    Use this function to validate the arguments before creating an education item.
*/
#let validate-education-item-args(
  institution,
  degree,
  location,
  award,
  start-date,
  end-date,
  activities
) = {
  assert(type(institution) == str and institution != "", message: "Institution must be a non-empty string.")

  assert(type(degree) == str and degree != "", message: "Degree must be a non-empty string.")

  
  if award != none {
    assert(type(award) == str, message: "Award must be a string if provided.")
  }

  if location != none {
    assert(type(location) == str, message: "Location must be a string if provided.")
  }

  if activities != none {
    assert(type(activities) == array, message: "Activities must be an array if provided.")
    for (i, activity) in activities.enumerate() {
      assert(type(activity) == str and activity != "", message: "Activity at index " + str(i) + " must be a non-empty string.")
    }
  }

  if type(start-date) == dictionary {
    validate-date-dictionary(start-date)
  } else {
    assert(type(start-date) == datetime, message: "start-date must be a datetime or a valid date dictionary.")
  }

  if type(end-date) == dictionary {
    validate-date-dictionary(end-date)
  } else {
    assert(type(end-date) == datetime or end-date == "Present", message: "end-date must be a datetime, 'Present', or a valid date dictionary.")
  }
}

/* 
  Renders an education item with specified details.

  Parameters:
    - `institution`: The name of the educational institution.
    - `degree`: The degree obtained.
    - `start-date`: The start date of the education period. Default is `datetime.today()`.
    - `end-date`: The end date of the education period. Default is `"Present"`.
    - `location`: The location of the institution. Default is `none`.
    - `award`: Any awards received. Default is `none`.
    - `activities`: A list of activities or achievements. Default is `none`.

  Returns:
    - A rendered education item.

  Panics:
    - If the input arguments are invalid as per `validate-education-item-args`.

  Usage:
    Use this function to render an education item in the resume's education section.
*/
#let education-item(institution,  degree, start-date: datetime.today(), end-date: "Present", location: none, grade: none, activities: none, col1-width: 70%,
col2-width: 30%,
spacing-between-main-and-activities: -0.25em) = {

  validate-education-item-args(
    institution,
    degree,
    location,
    grade,
    start-date,
    end-date,
    activities
  )


  let activities-list = if type(activities) == array and activities.len() > 0 {
    list(..activities)
  } else {
    none
  }

  let degree-content = degree + if grade != none {
    ", " + emph(grade)
  } else {
    ""
  }

  let tenure = date-range-content(start-date: start-date, end-date: end-date, string-formatting: "short-month-year")

  generic-2x2-grid(
    widths: (col1-width, col2-width),
    r1c1: [*#institution*],
    r1c2: [#tenure],
    r2c1: [#degree-content],
    r2c2: location,
  )
 
  if type(activities) == array and activities.len() > 0 {
    v(spacing-between-main-and-activities)
    [
    #activities-list
    ]
  }
}

/*
  Validates the data structure for the Education section.

  Parameters:
    - `data`: The education section data to validate.

  Panics:
    - If the data is not an array of valid education entries.

  Usage:
    Use this function to validate the education section data before rendering.
*/
#let verify-education-section-data(data) = {
  assert(type(data) == array, message: "Education section data must be an array.")
  for (i, entry) in data.enumerate() {
    assert(type(entry) == dictionary, message: "Education entry at index " + str(i) + " must be a dictionary.")
    assert(
      "institution" in entry and type(entry.institution) == str and entry.institution != "",
      message: "Education entry at index " + str(i) + " must have a non-empty 'institution' field.",
    )
  
    assert(
      "degree" in entry and type(entry.degree) == str and entry.degree != "",
      message: "Education entry at index " + str(i) + " must have a non-empty 'degree' field.",
    )

    if "location" in entry {
      assert(type(entry.location) == str, message: "Location in education entry at index " + str(i) + " must be a string.")
    }
    
    if "grade" in entry {
      assert(type(entry.grade) == str, message: "Grade in education entry at index " + str(i) + " must be a string.")
    }

    assert(
      "start-date" in entry and type(entry.at("start-date")) == dictionary and "year" in entry.at("start-date") and "month" in entry.at("start-date") and "day" in entry.at("start-date"),
      message: "Education entry at index " + str(i) + " must have a valid 'start-date' dictionary with 'year', 'month', and 'day'.",
    )

    assert(
      "end-date" in entry and (type(entry.at("end-date")) == dictionary and "year" in entry.at("end-date") and "month" in entry.at("end-date") and "day" in entry.at("end-date") or entry.at("end-date") == "Present"),
      message: "Education entry at index " + str(i) + " must have a valid 'end-date' dictionary or the string 'Present'.",
    )

    if "activities" in entry {
      assert(type(entry.at("activities")) == array, message: "Activities in education entry at index " + str(i) + " must be an array.")
    }
  }
}

#let education-section(data, spacing-between-items: 0.55em) = {

  // Validates and renders the Education section.
  verify-education-section-data(data)

  let education-items = data.map((entry) => [ 
    #education-item(
    entry.institution,
    entry.degree,
    start-date: entry.at("start-date"),
    end-date: entry.at("end-date"),
    location: entry.location,
    grade: if "grade" in entry { entry.grade } else { none },
    activities: if "activities" in entry { entry.activities } else { none },
  )
  ])

  let education-content = education-items.join(v(spacing-between-items))

  

  [
    #section-heading("Education")
    #section-content(
      education-content,

    )
  ]
}

