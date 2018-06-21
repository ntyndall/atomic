#' @title Parse Overwrite
#'
#' @description A function that takes a value and checks that is
#'  of the form of the allowed values.
#'
#' @param val A character string defining the value of the \code{overwrite}
#'  option.
#' @param allowedVals A character vector of strings that \code{val} must take.
#'
#' @export


parse_overwrite <- function(val, allowedVals = c("true", "false", "t", "f")) {
  return(
    if (val %in% allowedVals) {
      val %>% toupper %>% as.logical
    } else {
      cat(crayon::yellow("    ## -o must be one of true / false (defaulting to false) \n"))
      FALSE
    }
  )
}

#' @title Parse Conversion
#'
#' @description A function that takes a value and checks that is
#'  of the form of the allowed values.
#'
#' @param val A character string defining the value of the \code{conversion}
#'  option.
#' @param allowedVals A character vector of strings that \code{val} must take.
#'
#' @export


parse_conversion <- function(val, allowedVals = c("icm", "ev", "ryd")) {
  return(
    if (val %in% allowedVals) {
      val %>% `==`(allowedVals) %>% which %>% `-`(1)
    } else {
      cat(crayon::yellow("    ## -c must be one of icm / ev / ryd (defaulting to ev) \n"))
      1
    }
  )
}

#' @title Parse Series
#'
#' @description A function that sends a post query to NIST to
#'  retrieve the HTTP response containing the level information
#'  in the form of a table, nested in an XML nodeset.
#'
#' @details This function checks to see if a series is valid or
#'  not, and can take multiple formats and parses it into something
#'  valid for sending the query. It probably works either way, but
#'  I can at least let this fail early if it doesn't look the way it
#'  should. Element and series number formats can consist of
#'    \itemize{
#'      \item{\code{Helium / helium / He / he}}
#'      \item{\code{2 / 1 / ii / i}}
#'    }
#'
#' @param series A character string containing an ionic series.
#'
#' @export


parse_series <- function(series) {

  # Period table
  PT <- atomic::periodic.table

  # Split by underscore first
  splitSeries <- series %>%
    strsplit(split = '_') %>%
    purrr::flatten_chr()

  # Make sure it has all required details
  if (splitSeries %>% length %>% `!=`(2)) stop('')

  # Create a named list
  splitSeries %<>% as.list
  names(splitSeries) <- c("name", "series")

  # All possible element combinations
  allElements <- c(PT$element %>% as.character, PT$symbol %>% as.character)

  # Uppercase first letter in the series
  splitSeries$name %<>% stringr::str_to_title()

  # Check if either format exists + return back the symbol
  if (splitSeries$name %in% allElements) {
    index <- splitSeries$name %>%
      `==`(allElements) %>%
      which %>%
      `%%`(PT %>% nrow)
    elementDetails <- PT[index, ]
  } else {
    stop(" ## Element provided by -e not found.")
  }

  # Now check the series required
  splitSeries$series %<>% atomic::check_series_num(PT = PT)

  # Make sure it doesn't exceed what is allowed, else convert to roman numeral
  if (splitSeries$series >= elementDetails$atomicNumber) {
    stop(" ## This series isn't permitted (try something lower).")
  } else {
    splitSeries$series %<>% `+`(1) %>% as.roman
  }

  # Finally, return the series as a list
  return(paste0(splitSeries$name, " ", splitSeries$series %>% tolower))
}
