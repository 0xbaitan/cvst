#import "@preview/oxifmt:1.0.0": strfmt

// ================================
// Dates Utils
// ================================

/*
  Validates the structure of a date dictionary.

  Parameters:
    - `date-dict`: A dictionary expected to contain the keys `year`, `month`, and `day`, each with integer values.

  Panics:
    - If `date-dict` is not a dictionary or does not contain the required keys.
    - If the values for `year`, `month`, or `day` are not integers.
    - If `month` is not between 1 and 12.
    - If `day` is not between 1 and 31.
    - If `year` is not between 1900 and 2100.

  Usage:
    Use this function to ensure that a date dictionary has the correct structure and valid values before using it in date-related operations.
*/
#let validate-date-dictionary(date-dict) = {

  assert(type(date-dict) == dictionary and "year" in date-dict and "month" in date-dict and "day" in date-dict, message: "Expected 'date-dict' to be a dictionary with 'year', 'month', and 'day' keys.")

  assert(
    type(date-dict.year) == int and type(date-dict.month) == int and type(date-dict.day) == int,
    message: "Expected 'year', 'month', and 'day' in 'date-dict' to be integers."
  )

  assert(
    date-dict.month >= 1 and date-dict.month <= 12,
    message: "Expected 'month' in 'date-dict' to be between 1 and 12."
  )

  assert(
    date-dict.day >= 1 and date-dict.day <= 31,
    message: "Expected 'day' in 'date-dict' to be between 1 and 31."
  )

  assert(
    date-dict.year >= 1900 and date-dict.year <= 2100,
    message: strfmt("Expected 'year' in 'date-dict' to be between 1900 and {}.", 2100)
  )
}

/* 
  Normalises various date input formats into a datetime object or "Present" literal.

  Parameters:
    - `date-val`: The date input to normalise. Can be a date dictionary (with `year`, `month`, `day`), the string literal "Present", or a datetime object.

  Returns:
    - A datetime object if `date-val` is a valid date dictionary or datetime.
    - The string literal "Present" if `date-val` is "Present".

  Panics:
    - If `date-val` is not a valid date dictionary, "Present", or a datetime object.

  Usage:
    Use this function to convert various date input formats into a consistent format for further processing.
*/
#let validate-and-normalise-date-input(date-val) = {
   if type(date-val) == dictionary {
    validate-date-dictionary(date-val)
    datetime(
      year: date-val.year,
      month: date-val.month,
      day: date-val.day,
    )
  } else if date-val == "Present" or type(date-val) == datetime {
    date-val
  } else {
    panic("Invalid date input. Expected a date dictionary (with 'year', 'month', 'day'), 'Present' literal, or a datetime object.")
  }
}

/**
  Enum mapping for date string formatting options.

  Values are format strings compatible with the `datetime.display()` method.

  Available keys with examples:
    - "year-only": "2023"
    - "long-month-year": "January 2023"
    - "short-month-year": "Jan 2023"
    - "numeric-month-year-slash": "01/2023"
    - "numeric-month-year-hyphen": "01-2023"
    - "numeric-month-short-year-slash": "01/23"
    - "numeric-month-short-year-hyphen": "01-23"
    - "full-date": "15 January 2023"
    - "iso-date": "2023-01-15"

  Usage:
    Use this enum to retrieve the appropriate date format string for displaying dates in various formats.
*/
#let date-string-formatting-enum = (
   "year-only": "[year]", // e.g., 2023
   "long-month-year": "[month repr:long] [year]", // e.g., January 2023
   "short-month-year": "[month repr:short] [year]", // e.g., Jan 2023
   "numeric-month-year-slash": "[month repr:numerical padding:zero]/[year]", // e.g., 01/2023
   "numeric-month-year-hyphen": "[month repr:numerical padding:zero]\u{002D}[year]", // e.g., 01-2023
   "numeric-month-short-year-slash": "[month repr:numerical padding:zero]/[year repr:short]", // e.g., 01/23
   "numeric-month-short-year-hyphen": "[month repr:numerical padding:zero]\u{002D}[year repr:short]", // e.g., 01-23,
   "full-date": "[day padding:zero] [month repr:long] [year]", // e.g., 15 January 2023
   "iso-date": "[year]-[month repr:numerical padding:zero]-[day padding:zero]", // e.g., 2023-01-15,
)

/*
  Retrieves the date string formatting enum value for a given key.

  Parameters:
    - `key`: The key representing the desired date string format.

  Returns:
    - The corresponding format string from the `date-string-formatting-enum`.

  Panics:
    - If the provided `key` is not found in the `date-string-formatting-enum`.

  Usage:
    Use this function to get the appropriate date format string for displaying dates.
*/
#let get-date-string-formatting-enum(key) = {
  assert(
    key in date-string-formatting-enum,
    message: strfmt("Invalid date string formatting key '{}'. Expected one of: {}.", key, date-string-formatting-enum.keys().join(", "))
  )
  {date-string-formatting-enum.at(key)}
}

/* 
  Formats a date value into a string based on the specified formatting option.

  Parameters:
    - `date-val`: The date input to format. Can be a date dictionary (with `year`, `month`, `day`), the string literal "Present", or a datetime object.
    - `string-formatting`: A key representing the desired date string format. Default is "long-month-year".

  Returns:
    - A formatted date string if `date-val` is a valid date dictionary or datetime.
    - The string literal "Present" if `date-val` is "Present".

  Panics:
    - If `date-val` is not a valid date dictionary, "Present", or a datetime object.
    - If `string-formatting` is not a valid key in the `date-string-formatting-enum`.

  Usage:
    Use this function to convert various date input formats into a formatted date string for display.
*/
#let format-date(date-val, string-formatting: "long-month-year") = {
  let normalised-date = validate-and-normalise-date-input(date-val)
  if type(normalised-date) == datetime {
    return normalised-date.display(get-date-string-formatting-enum(string-formatting))
  } else {
    return normalised-date // "Present"
  }
}

/*
  Generates content representing a date range from start to end dates.

  Parameters:
    - `start-date`: The start date input. Can be a date dictionary (with `year`, `month`, `day`), the string literal "Present", or a datetime object.
    - `end-date`: The end date input. Can be a date dictionary (with `year`, `month`, `day`), the string literal "Present", or a datetime object.
    - `string-formatting`: A key representing the desired date string format for both start and end dates. Default is "long-month-year".

  Returns:
    - Content representing the date range in the format "Start Date -- End Date".

  Panics:
    - If either `start-date` or `end-date` is not a valid date dictionary, "Present", or a datetime object.
    - If `string-formatting` is not a valid key in the `date-string-formatting-enum`.

  Usage:
    Use this function to create a consistent representation of a date range for display purposes.
*/
#let date-range-content(start-date: datetime.today(), end-date: "Present", string-formatting: "long-month-year") = {
  let startDateStr = format-date(start-date, string-formatting: string-formatting)
  let endDateStr = format-date(end-date, string-formatting: string-formatting)

  return [
    #startDateStr -- #endDateStr
  ]
}


// ================================



