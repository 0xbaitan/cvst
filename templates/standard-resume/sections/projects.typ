#import "../utils/sections.typ": section-heading, section-content



#let project-item(name: "", stack: none, project-url: none, activities: none, spacing-between-main-and-activities: -0.25em, spacing-between-title-and-stack: 0.25em) = {

 
  let project-title-content = if type(project-url) == str and project-url.starts-with(regex("^https?://")) {
    link(project-url)[*#name*]
  } else {
    [*#name*]
  }

  let stack-list-content = if type(stack) == array and stack.len() > 0 {
    stack.join(", ")
  } else {
    none
  }
  
  let activities-list = if type(activities) == array and activities.len() > 0 {
    list(..activities)
  } else {
    none
  }

  [
    #project-title-content
    #if stack-list-content != none {
      [
      #h(spacing-between-title-and-stack/2)
      |
      #h(spacing-between-title-and-stack/2)
      #emph(stack-list-content)
      ]
    }
    #if activities-list != none {
      v(spacing-between-main-and-activities)
      [
        #activities-list
      ]
    }
  ]
}

#let validate-project-section-data(data) = {
  assert(type(data) == array, message: "Projects section data must be an array.")
  for (i, entry) in data.enumerate() {
    assert(type(entry) == dictionary)
    assert(
      "name" in entry and type(entry.name) == str and entry.name != "",
      message: "Project entry at index " + str(i) + " must have a non-empty 'name' field.",
    )
    assert(
      "stack" in entry and (type(entry.stack) == str or type(entry.stack) == array),
      message: "Project entry at index " + str(i) + " must have a 'stack' field of type string or array.",
    )

    if "url" in entry {
      assert(type(entry.at("url")) == str or entry.at("url") == none, message: "URL in project entry at index " + str(i) + " must be of type string or none.")
    }
    
    assert(
      "activities" in entry and (type(entry.activities) == array or entry.activities == none),
      message: "Project entry at index " + str(i) + " must have an 'activities' field of type array or none.",
    )
  }
}

#let projects-section(data, spacing-between-items: 0.55em) = {
  // Validates and renders the Projects section.
  validate-project-section-data(data)

  let projects-content = data.map((entry) => {
    project-item(
      name: entry.name,
      stack: entry.stack,
      project-url: if "url" in entry { entry.at("url") } else { none },
      activities: entry.activities
    )
  }).join(v(spacing-between-items))

  [
    #section-heading("Projects")
    #section-content(projects-content)
  ]
}
