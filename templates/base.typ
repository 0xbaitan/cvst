#let v-space-small = 0.3em // Between bullets/list items
#let v-space-medium = 0.5em // After headings/entries
#let v-space-large = 0.8em // Between major sections
#let h-space-small = 0.25em // Around separators like |
#let h-space-medium = 0.4em // Around inline elements







#let resume(

  paper: "a4",
  top-margin: 0.4in,
  bottom-margin: 0.2in,
  left-margin: 0.3in,
  right-margin: 0.3in,
  font: "New Computer Modern",
  font-size: 11pt,
  personal-info-font-size: 10.5pt,
  author-name: "",
  author-position: center,
  personal-info-position: center,
  phone: "",
  location: "",
  email: "",
  website: "",
  linkedin-user-id: "",
  github-username: "",
  visa-info: "",
  body,
  heading-color: cmyk(60%, 40%, 40%, 100%),
) = {
  set document(
    title: "Resume | " + author-name,
    author: author-name,
    keywords: "resume, software engineer, developer, cv",
    date: none,
  )

  set page(
    paper: paper,
    height: auto,
    margin: (
      top: top-margin,
      bottom: bottom-margin,
      left: left-margin,
      right: right-margin,
    ),
  )

  set text(
    font: font,
    size: font-size,
    lang: "en",
    ligatures: false,
  )

  show heading.where(
    level: 1,
  ): it => block(width: 100%)[
    #set text(font-size + 2pt, weight: "bold", fill:
      rgb(heading-color))
    #smallcaps(it.body)
    #v(-v-space-large)
    #line(length: 100%, stroke: stroke(thickness: 0.4pt))
    #v(0.05em)
  ]

  let contact_item(value, link-type: "", prefix: "") = {
    if value != "" {
      if link-type != "" {
        underline(offset: 0.3em)[#link(link-type + value)[#(prefix + value)]]
      } else {
        value
      }
    }
  }

  align(author-position, [
    #upper(text(font-size + 12pt, weight: "extrabold")[#author-name])
    #v(-1.25em)
  ])


  align(personal-info-position, text(personal-info-font-size)[
    #{
      let sepSpace = 0.2em
      let items = (
        contact_item(phone),
        contact_item(location),
        contact_item(email, link-type: "mailto:"),
        contact_item(website, link-type: "https://"),
        contact_item(linkedin-user-id, link-type: "https://linkedin.com/in/", prefix: "linkedin.com/in/"),
        contact_item(github-username, link-type: "https://github.com/", prefix: "github.com/"),
        contact_item(visa-info),
      )
      items
        .filter(x => x != none)
        .join([
          #show "|": sep => {
            h(sepSpace)
            [|]
            h(sepSpace)
          }
          |
        ])
    }
  ])

  body
}

// ---
// Custom functions

#let generic_1x2(r1c1, r1c2) = {
  grid(
    columns: (2fr, 1fr),
    align(left)[#r1c1], align(right)[#r1c2],
  )
  v(v-space-medium)
}

#let generic_2x2(cols, r1c1, r1c2, r2c1, r2c2) = {
  // sanity checks
  assert.eq(type(cols), array)

  grid(
    columns: cols,
    align(left)[#r1c1 \ #r2c1],
    align(right)[#r1c2 \ #r2c2]
  )
  v(v-space-medium)
}

#let custom-title(title, space-below: 0.15em, body) = {
  set par(leading: v-space-medium)
  [= #title]
  body
  v(-0.05em)
}

// Custom list to be used inside custom-title section.
#let skills(body) = {
  if body != [] {
    set par(leading: v-space-medium)
    set list(
      body-indent: 0.1em,
      indent: 0em,
      marker: [],
    )
    body
  }
}



#let certification(
  certification,
  certificate-issuer: none,
  certificate-url: none,
  issued-date: none,
  expiry-date: none,
) = {
  let issuer-text = if certificate-issuer != none {
    certificate-issuer
  } else {
    none
  }

  generic_1x2(
    {
      if certificate-url != none {
        link(certificate-url)[*#certification*]
      } else {
        [*#certification*]
      }

      if issuer-text != none {
        h(v-space-small) + [|] + h(v-space-small) + emph(issuer-text)
      }
    },
    {
      // Show only issued date if expiry is not mentioned, otherwise show range
      if issued-date != none and expiry-date == none {
        strong(issued-date.display("[month repr:short] [year]"))
      } else if issued-date != none and expiry-date != none {
        strong(
          issued-date.display("[month repr:short] [year]")
            + strong()[ -- ]
            + expiry-date.display("[month repr:short] [year]"),
        )
      } else {
        none
      }
    },
  )
  v(-1em)
}


// Converts datetime format into readable period.
#let period_worked(start-date, end-date) = {
  // sanity checks
  assert.eq(type(start-date), datetime)
  assert(type(end-date) == datetime or type(end-date) == str)

  if type(end-date) == str and end-date == "Present" {
    end-date = datetime.today()
  }

  return [
    #start-date.display("[month repr:short] [year]") --
    #if (
      (end-date.month() == datetime.today().month()) and (end-date.year() == datetime.today().year())
    ) [
      Present
    ] else [
      #end-date.display("[month repr:short] [year]")
    ]
  ]
}



// Pretty self-explanatory.
#let work-heading(title, company, location, start-date, end-date, body) = {
  // sanity checks
  assert.eq(type(start-date), datetime)
  assert(type(end-date) == datetime or type(end-date) == str)

  generic_2x2(
    (2fr, 1fr),
    [*#title*],
    [*#period_worked(start-date, end-date)*],
    [#company],
    emph(location),
  )
  v(-v-space-small)
  if body != [] {
    v(-v-space-small)
    set par(leading: v-space-medium)
    set list(indent: 0.5em, spacing: v-space-large)
    body
  }
  v(v-space-medium)
}

// Pretty self-explanatory.
#let project-heading(name, stack: "", project-url: "", body) = {
  if project-url.len() != 0 { link(project-url)[*#name*] } else {
    [*#name*]
  }
  if stack != "" {
    [
      #show "|": sep => {
        h(0.05em)
        [|]
        h(0.05em)
      }
      | #emph(stack)
    ]
  }
  v(-v-space-small)
  if body != [] {
    v(v-space-small)
    set par(leading: v-space-medium)
    set list(indent: 0.5em, spacing: v-space-large)
    body
  }
  v(v-space-medium)
}




// Pretty self-explanatory.
#let education-heading(institution, location, degree, award, start-date, end-date, body) = {

  // sanity checks
  assert.eq(type(start-date), datetime)
  assert(type(end-date) == datetime or type(end-date) == str)



  generic_2x2(
    (80%, 20%),
    [*#institution*],
    strong(period_worked(start-date, end-date)),
    [#degree, #award],
    emph(location),
  )
  v(-v-space-small)
  if body != [] {
    v(-v-space-small)
    set par(leading: v-space-medium)
    set list(indent: 0.5em, spacing: v-space-large)
    body
  }
}


#let experience-section(data) = {
  custom-title("Experience")[

    #assert(type(data) == array)

    #for entry in data {
      assert(
        type(entry.startDate) == dictionary and "year" in entry.startDate and "month" in entry.startDate and "day" in entry.startDate
      )

      assert(
        type(entry.endDate) == dictionary and "year" in entry.endDate and "month" in entry.endDate and "day" in entry.endDate
        or entry.endDate == "Present"
      )

      let startDateVal = datetime(
        year: entry.startDate.year,
        month: entry.startDate.month,
        day: entry.startDate.day,
      )

      let endDateVal = if type(entry.endDate) == dictionary {
        datetime(
          year: entry.endDate.year,
          month: entry.endDate.month,
          day: entry.endDate.day,
        )
      } else {
        "Present"
      }

      work-heading(
        entry.title,
        entry.company,
        entry.location,
        startDateVal,
        endDateVal,
      )[
        #for bullet in entry.activities [
          - #bullet
        ]
      ]
    }
  ]
 
}


#let verify-skills-section-data(data) = {
  assert(type(data) == array)

  for (i, skill) in data.enumerate() {
    assert(
      type(skill) == dictionary
    )
    assert(
      "category" in skill and type(skill.category) == str and skill.category != ""
    )
    assert(
      "items" in skill and type(skill.items) == array and skill.items.len() > 0
    )
    for (j, item) in skill.items.enumerate() {
      assert(
        type(item) == str and item != ""
      )
    }
  }
}

#let verify-certification-section-data(data) = {
  assert(type(data) == array, "Certifications section data must be an array.")

  for (i, cert) in data.enumerate() {
    assert(type(cert) == dictionary)
    assert(
      "title" in cert and type(cert.title) == str and cert.title != "",
      message: "Certification entry at index " + i.str() + " must have a non-empty 'title' field.",
    )

    if "issuer" in cert {
      assert(type(cert.issuer) == str and cert.issuer != "", message: "Issuer in certification entry at index " + i.str() + " must be a non-empty string.")
    }

    assert(
      "issuanceDate" in cert and type(cert.issuanceDate) == datetime, message: "Certification entry at index " + i.str() + " must have a valid 'issuanceDate' field of type datetime.",
    )

    if "expirationDate" in cert {
      assert(
        type(cert.expirationDate) == datetime or cert.expirationDate == "Present", message: "Expiration date in certification entry at index " + i.str() + " must be either a datetime or the string 'Present'."
      )
    }

    if "credentialID" in cert {
      assert(type(cert.credentialID) == str and cert.credentialID != "", message: "Credential ID in certification entry at index " + i.str() + " must be a non-empty string.")
    }

    if "credentialURL" in cert {
      assert(type(cert.credentialURL) == str and cert.credentialURL != "", message: "Credential URL in certification entry at index " + i.str() + " must be a non-empty string.")
    }

    if "description" in cert {
      assert(type(cert.description) == str, message: "Description in certification entry at index " + i.str() + " must be a string.")
    }
  }
}

#let skills-section(data) = {
  verify-skills-section-data(data)

  custom-title("Skills")[
      #set list(marker: none)
      #for skill in data [
        #let skill-text = strong(skill.category + ":") + " " + skill.items.join(", ")
        - #text(skill-text)
      ]
  ]

}