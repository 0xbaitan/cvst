
#import "../utils/sections.typ": section-heading, section-content


#let certification-item(
  title,
  issuer: none,
  certificate-url: none,
  spacing-between-title-and-issuer: 0.5em
) = {
  
  let title-content = if type(certificate-url) == str and certificate-url.starts-with(regex("^https?://")) {
    [#link(certificate-url)[*#title*]]
  } else {
    [*#title*]
  }
  [
    #title-content
    #if issuer != none {
      [
        #h(spacing-between-title-and-issuer/2)
        |
        #h(spacing-between-title-and-issuer/2)
        #emph(issuer)
      ]
    }
  ]
}


#let verify-certification-section-data(data) = {
  assert(type(data) == array, message: "Certifications section data must be an array.")

  for (i, cert) in data.enumerate() {
    assert(type(cert) == dictionary)
    assert(
      "title" in cert and type(cert.at("title")) == str and cert.at("title") != "",
      message: "Certification entry at index " + str(i) + " must have a non-empty 'title' field.",
    )

    if "issuer" in cert {
      assert(type(cert.at("issuer")) == str and cert.at("issuer") != "", message: "Issuer in certification entry at index " + str(i) + " must be a non-empty string.")
    }

  
    if "credential-url" in cert {
      assert(type(cert.at("credential-url")) == str and cert.at("credential-url") != "", message: "Credential URL in certification entry at index " + str(i) + " must be a non-empty string.")
    }

  }
}

#let certifications-section(data, spacing-between-items: -0.55em) = {
  // Validates and renders the Certifications section.
  verify-certification-section-data(data)

  let certification-items = data.map((cert) => [ 
    #certification-item(
      cert.title,
      issuer: if "issuer" in cert { cert.issuer } else { none },
      certificate-url: if "credential-url" in cert { cert.at("credential-url") } else { none },
    )
  ])

  let certifications-content = certification-items.join(v(spacing-between-items))

  [
    #section-heading("Certifications")
    #section-content(certifications-content)
  ]
}

#certifications-section((
  (title: "Certified Kubernetes Administrator", issuer: "Cloud Native Computing Foundation", credential-url: "https://www.yourcertlink.com/certificate/12345"),
  (title: "AWS Certified Solutions Architect", issuer: "Amazon Web Services", credential-url: "https://www.yourcertlink.com/certificate/67890")
))