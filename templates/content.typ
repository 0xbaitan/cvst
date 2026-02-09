#import "./base.typ": *

#let data = yaml("../data/test.resume.yaml")

// Settings from data file
#let name = if "name" in data.sections.contact { data.sections.contact.name } else { 
  ()
}

#let phone = data.sections.contact.phone
#let email = data.sections.contact.email
#let github = data.sections.contact.githubUsername
#let linkedin = data.sections.contact.linkedInHandle

#show: resume.with(
  top-margin: 0.5in,
  bottom-margin: 0.5in,
  right-margin: 0.5in,
  left-margin: 0.5in,
  font: "Carlito",
  font-size: 10.5pt,
  personal-info-font-size: 10pt,
  location: "Slough, UK",
  author-position: center,
  personal-info-position: center,
  author-name: name,
  phone: phone,
  email: email,
  linkedin-user-id: linkedin,
  github-username: github,
  heading-color: data.settings.sections.headings.color,
)

#custom-title("Summary")[
  #set par(leading: 0.5em)
  #text(
    data.sections.summary.sentences.map((sentence) => sentence.trim()).join(" ")
  )
]

#let education-entries = data.sections.education

#custom-title("Education")[

  #for entry in education-entries {

    assert(type(entry.startDate) == dictionary and "year" in entry.startDate and "month" in entry.startDate and "day" in entry.startDate)

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

     
    education-heading(
      entry.institution,
      entry.location,
      entry.degree,
      entry.grade,
      startDateVal,
      endDateVal,
    )[
      #if "activities" in entry {
        set list(indent: 0.5em, spacing: 0.2em)
        entry.activities.map(bullet => [- #bullet])
      }
    ]
  }
]

#experience-section(data.sections.experience)



#custom-title("Projects")[


  #project-heading(
    "BiaPlanner: Meal Planning Web App",
    stack: "TypeScript, React, Redux, NestJS, MySQL, Docker",
  )[
    - Engineered a full-stack meal planning web app with features to prepare meal plans, customise recipes, track inventory, generate shopping lists, and send food expiry alerts.
    - Architected various UML diagrams to guide the development of scalable services, database schemas and data flow.
    - Applied user-centred design by creating and referencing 30+ wireframes paired with usability testing.
  ]

  // #project-heading(
  //   "Application Load Balancer",
  //   stack: "Java, Docker, Apache JMeter",
  // )[
  //   - Engineered a thread-safe Round Robin load balancer using Java and Docker with automatic service discovery and health monitoring capabilities.
  //   - Performed load testing with Apache JMeter by simulating 1000 concurrent user connections, achieving 8ms latency with zero errors with even load distribution across services.
  // ]


  #project-heading(
    "Cancer Data Clustering and Classification Model (Python, Jupyter Notebook)",
  )[
    - Engineered a semi-supervised ML model with Python and Jupyter Notebook to classify six cancer types achieving 94.5% accuracy across 494 data samples extracted from The Cancer Genome Atlas dataset.

  ]
]

#skills-section(data.sections.skills)



#custom-title("Certifications")[

  #certification(
    "Microsoft Certified: Azure Fundamentals",
    certificate-issuer: "Microsoft",
    certificate-url: "https://learn.microsoft.com/en-us/users/tanishbaidya-9434/credentials/195888a0f71159cf?ref=https%3A%2F%2Fwww.linkedin.com%2F",
  )


  #certification(
    "AWS Certified Cloud Practitioner",

    certificate-issuer: "Amazon Web Services",
    certificate-url: "https://www.credly.com/badges/1d46564b-6cb1-4fd8-ae17-0daf91f82eac/public_url
",
  )
]


