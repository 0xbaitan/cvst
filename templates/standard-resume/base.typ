
#import "./sections/certifications.typ": certifications-section
#import "./sections/education.typ": education-section
#import "./sections/experience.typ": experience-section
#import "./sections/projects.typ": projects-section
#import "./sections/contact.typ": contact-section
#import "./sections/skills.typ": skills-section
#import "./sections/summary.typ": summary-section





#let set-page-settings(
  data
) = {
 
  if(type(data) != dictionary) {
    panic("Page settings data must be a dictionary.")
  }

  if("settings" not in data or type(data.at("settings")) != dictionary) {
    return
  }


  let page-settings = ()

  if("paper" in data.settings and type(data.settings.at("paper")) == str) {
    page-settings = page-settings.insert("paper", data.settings.paper)
  }


  
  set page(
    margin: (
      top: if "margin-top" in data { data.at("margin-top") } else { 0.5in },
      bottom: if "margin-bottom" in data { data.at("margin-bottom") } else { 0.5in },
      left: if "margin-left" in data { data.at("margin-left") } else { 0.5in },
      right: if "margin-right" in data { data.at("margin-right") } else { 0.5in },
    )
  )
  
  }

#let base-resume(
  data
) = {

  set document(
    title: "Resume",
  )

  if data == none {
    panic("No data provided to resume template.")
  }

    set page(
    paper: "a4",
  
    margin: (
      top: 0.5in,
      bottom: 0.5in,
      left: 0.5in,
      right: 0.5in,
    ),
  )

  set text(
    font: "Carlito",
    size: 12pt,
    lang: "en",
    ligatures: false,
  )


  [
    #contact-section(data.sections.contact)
    #summary-section(data.sections.summary)
    #education-section(data.sections.education)
    #experience-section(data.sections.experience)
    #certifications-section(data.sections.certifications)
    #skills-section(data.sections.skills)
    #projects-section(data.sections.projects)
    
  ]

}