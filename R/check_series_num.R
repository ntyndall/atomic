#' @title Check Series Number
#'
#' @description A function that tries to parse and format the
#'  series that is being investigated into an integer value.
#'
#' @param num A character vector containing the series details.
#' @param PT A data frame that contains the periodic table
#'  information.
#' @export

check_series_num <- function(num, PT) {

  # Check the format of the input
  res <- if (num %>% Hmisc::all.is.numeric()) {
    num %>% as.integer
  } else {
    # Check if it is roman numerals or can be split to a series like object
    num %>% as.roman %>% as.integer %>% `-`(1)
  }

  # Return the result as a roman numeral back
  return(res)
}
