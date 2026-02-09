#import "@preview/oxifmt:1.0.0": strfmt

/*
  Validates the arguments for a contact item.

  Parameters:
    - `value`: The contact information value. Must be a string.
    - `link-type`: The type of link to create. Must be either `none` or a string starting with "http://", "https://", or "mailto:".
    - `prefix`: An optional prefix to display before the contact value. Must be a string or `none`.
  Panics:
    - If `value` is not a string.
    - If `link-type` is not `none` or a valid string as described.
    - If `prefix` is not a string or `none`.
  Usage:
    Use this function to ensure that arguments passed to a contact item utility are valid before proceeding with rendering logic.
*/
#let validate-contact-item-args(value, link-type, prefix) = {
  assert(
    type(value) == str,
    message: "Contact item 'value' must be a string."
  )

  assert(
    link-type == none or (type(link-type) == str and link-type.starts-with(regex("^(https?://|mailto:)$"))),
    message: "Contact item 'link-type' must be either none or a string starting with 'http://', 'https://', or 'mailto:'."
  )

  assert(
    type(prefix) == str or prefix == none,
    message: "Contact item 'prefix' must bbe a string or none."
  )
}


/* 
  Renders a contact item with optional link and prefix.

  Parameters:
    - `value`: The contact information value.
    - `link-type`: The type of link to create. Default is `none`.
    - `prefix`: An optional prefix to display before the contact value. Default is `none`.

  Returns:
    - A rendered contact item.

  Panics:
    - If the input arguments are invalid as per `validate-contact-item-args`.

  Usage:
    Use this function to render a contact item in the resume's contact section.
*/
#let contact-item(value, link-type: none, prefix: none) = {

  // Treat none as empty string for value, link-type, and prefix
  let v = if value == none { "" } else { value }
  let lt = if link-type == none { "" } else { link-type }
  let pf = if prefix == none { "" } else { prefix }

  if v != "" {
    if lt != "" {
      // If prefix is not empty, show prefix before value
      if pf != "" {
        underline(offset: 0.3em)[#link(lt + v)[#(pf + v)]]
      } else {
        underline(offset: 0.3em)[#link(lt + v)[#v]]
      }
    } else {
      if pf != "" {
        [#(pf + v)]
      } else {
        v
      }
    }
  }
  }


/*
 Validates a key-value pair for a contact item.

  Parameters:
    - `key`: The contact item key. Must be one of the predefined valid keys.
    - `value`: The contact item value. Must be a string.

  Panics:
    - If `key` is not one of the predefined valid keys.
    - If `value` is not a string.

  Usage:
    Use this function to ensure that key-value pairs for contact items are valid before proceeding with rendering logic.
*/
#let validate-contact-item-keyval-pair(key, value) = {
  
  let valid-keys = (
    "name",
    "phone",
    "email",
    "location",
    "website",
    "linkedin-user-id",
    "github-username",
  )

  assert(
    key in valid-keys,
    message: strfmt("Invalid contact item key: '{}'. Expected one of: {}.", key, valid-keys.join(", "))
  )

  assert(
    type(value) == str,
    message: strfmt("Contact item value for key '{}' must be a string.", key)
  )

}

/* 
  Validates the input data and constructs a "Contact" section for the resume.

  Parameters:
    - `data`: A dictionary containing the contact section data.
  
  Panics:
    - If `data` is not a dictionary.
    - If any expected keys in `data` are not strings.
    - If `personal-info-font-size` is not of type `length`.
    - If `personal-info-position` is not one of the expected strings.

  Usage:
    Use this template to create a contact section in the resume with validated input data.
*/
#let validate-contact-section-data(data) = {
  assert(
    type(data) == dictionary,
    message: "Expected 'data' to be a dictionary."
  )

  for (key, value) in data.pairs() {
    validate-contact-item-keyval-pair(key, value)
  }
}

  #let compute-contact-item-args(data) = {
    let phone = if "phone" in data { (
      value: data.at("phone"),
      link-type: none,
      prefix: none,
    ) } else { none }
    let email = if "email" in data { (
      value: data.at("email"),
      link-type: "mailto:",
      prefix: none,
    ) } else { none }
    let location = if "location" in data { (
      value: data.at("location"),
      link-type: none,
      prefix: none,
    ) } else { none }
    let website = if "website" in data { (
      value: data.at("website"),
      link-type: "https://",
      prefix: none,
    ) } else { none }
    let linkedin-user-id = if "linkedin-user-id" in data { (
      value: data.at("linkedin-user-id"),
      link-type: "https://linkedin.com/in/",
      prefix: "linkedin.com/in/",
    ) } else { none }
    let github-username = if "github-username" in data { (
      value: data.at("github-username"),
      link-type: "https://github.com/",
      prefix: "github.com/",
    ) } else { none }
    (phone, email, location, website, linkedin-user-id, github-username)
  }

#let contact-section(
  data,
  sep-space: 0.2em,
) = {
  validate-contact-section-data(data)


 
  let contact-item-args = compute-contact-item-args(data)
  
  let contact-items-list = contact-item-args.filter(item-args => item-args != none).map(item-args => contact-item(item-args.at("value"), link-type: item-args.at("link-type"), prefix: item-args.at("prefix")))

  [
  
    #set text(size: 2.4em, weight: "extrabold")
    #set par(leading: 0em, spacing: 0em)
    #set align(center)
    #upper(data.name) 
  ]
  [
     #set text(size: 1em)
     #set align(center)
    #contact-items-list.join([
      #h(sep-space)
      |
      #h(sep-space)
    ])
  ]

}


#contact-section(
  (
    name: "Tanish Baidya",
    phone: "+1 (555) 123-4567",
    location: "San Francisco, CA",
    email: "tanish.baidya@gmail.com",
    website: "www.tanishbaidya.com",
    linkedin-user-id: "tanish-baidya",
    github-username: "tanishbaidya",
  ),
  sep-space: 0.3em
)