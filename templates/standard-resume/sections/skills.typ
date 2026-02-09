#import "../utils/sections.typ": section-heading, section-content

#let verify-skills-section-data(data) = {
  assert(type(data) == array, message: "Skills section data must be an array.")
  for (i, skill) in data.enumerate() {
    assert(type(skill) == dictionary)
    assert(
      "category" in skill and type(skill.category) == str and skill.category != "",
      message: "Skill entry at index " + str(i) + " must have a non-empty 'category' field.",
    )
    assert(
      "items" in skill and type(skill.items) == array and skill.items.len() > 0,
      message: "Skill entry at index " + str(i) + " must have a non-empty 'items' array.",
    )
    for (j, item) in skill.items.enumerate() {
      assert(type(item) == str and item != "", message: "Skill item at index " + str(j) + " in skill entry " + str(i) + " must be a non-empty string.")
    }
  }
}

#let skills-section(data, space-between-items: -0.55em) = {
  // Validates and renders the Skills section.
  verify-skills-section-data(data)


  let skills-content = data.map((skill) => {
    let itemsStr = skill.items.join(", ")
    [#strong(skill.category + ": ") #itemsStr]
  }).join(v(space-between-items))
  

  [
    #section-heading("Skills")
    #section-content(skills-content)
  ]
}

#skills-section((
  (category: "Programming Languages", items: ("Python", "JavaScript", "C++")),
  (category: "Frameworks", items: ("Django", "React", "Flutter")

)))


  