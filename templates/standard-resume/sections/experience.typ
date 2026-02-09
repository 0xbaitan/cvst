#import "../utils/sections.typ": section-heading, section-content
#import "../utils/dates.typ": date-range-content
#import "../utils/grids.typ": generic-2x2-grid

#let verify-experience-section-data(data) = {
  assert(type(data) == array, message: "Experience section data must be an array.")
  for (i, entry) in data.enumerate() {
    assert(type(entry) == dictionary)
    assert(
      "title" in entry and type(entry.title) == str and entry.title != "",
      message: "Experience entry at index " + str(i) + " must have a non-empty 'title' field.",
    )
    assert(
      "company" in entry and type(entry.company) == str and entry.company != "",
      message: "Experience entry at index " + str(i) + " must have a non-empty 'company' field.",
    )
    assert(
      "location" in entry and type(entry.location) == str and entry.location != "",
      message: "Experience entry at index " + str(i) + " must have a non-empty 'location' field.",
    )
    assert(
      "start-date" in entry and type(entry.at("start-date")) == dictionary and "year" in entry.at("start-date") and "month" in entry.at("start-date") and "day" in entry.at("start-date"),
      message: "Experience entry at index " + str(i) + " must have a valid 'start-date' dictionary with 'year', 'month', and 'day'.",
    )
    assert(
      "end-date" in entry and (type(entry.at("end-date")) == dictionary and "year" in entry.at("end-date") and "month" in entry.at("end-date") and "day" in entry.at("end-date") or entry.at("end-date") == "Present"),
      message: "Experience entry at index " + str(i) + " must have a valid 'end-date' dictionary or the string 'Present'.",
    )
    assert(
      "activities" in entry and type(entry.activities) == array,
      message: "Experience entry at index " + str(i) + " must have an 'activities' array.",
    )
  }
}

#let experience-item(
  title,
  company,
  location: none,
  start-date: datetime.today(),
  end-date: "Present",
  activities: none,
  col1-width: 2fr,
  col2-width: 1fr,
  spacing-between-main-and-activities: -0.25em
) = {

  let period-worked = date-range-content(
    start-date: start-date,
    end-date: end-date,
    string-formatting: "long-month-year",
  )

  let activities-list = if type(activities) == array and activities.len() > 0 {
    list(..activities)
  } else {
    none
  }
  
  generic-2x2-grid(
    widths: (col1-width, col2-width),
    r1c1: strong(title),
    r1c2: [#period-worked],
    r2c1: [#company],
    r2c2: [#location],
  )

   if type(activities) == array and activities.len() > 0 {
    v(spacing-between-main-and-activities)
    [
    #activities-list
    ]
  }
}


#let experience-section(data, spacing-between-items: 0.55em) = {
  verify-experience-section-data(data)

  let experience-items = data.map((entry) => [ 
    #experience-item(
    entry.title,
    entry.company,
    start-date: entry.at("start-date"),
    end-date: entry.at("end-date"),
    location: if "location" in entry { entry.location } else { none },
    activities: if "activities" in entry { entry.activities } else { none },
  )
  ])

  let experience-content = experience-items.join(v(spacing-between-items))
  [
    #section-heading("Experience")
    #section-content(
      experience-content,
    )
  ]
}

#experience-section(
  (
    (title: "Software Engineer", company: "Tech Corp", location: "New York, NY", start-date: (year: 2020, month: 5, day: 1), end-date: (year: 2022, month: 8, day: 31), activities: ("Developed web applications using React and Node.js.", "Collaborated with cross-functional teams to define project requirements.")),
    (title: "Junior Developer", company: "Web Solutions", location: "San Francisco, CA", start-date: (year: 2018, month: 6, day: 15), end-date: (year: 2020, month: 4, day: 30), activities: ("Assisted in the development of client websites.", "Maintained and updated existing codebases.")),
  )
)
