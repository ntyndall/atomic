#' @title Get data
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


series_checker <- function(series) {

  # Period table
  PT <- atomic::periodic.table

  # Split by space first
  splitSeries <- series %>%
    strsplit(split = '[[:space:]]') %>%
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
    stop("Element provided by -e not found")
  }

  # Now check the series required
  # ...
}
