#' @title Check Series Number
#'
#' @description A function that tries to parse and format the
#'  series that is being investigated into an integer value.
#'
#' @param num A character vector containing the series details.
#' @param PT A data frame that contains the periodic table
#'  information.
#' @export

check_series_num <- function(num, current, PT) {

  # Check for `+` first
  if (num %>% grepl(pattern = "[+]")) num %<>% gsub(pattern = "[+]", replacement = "")

  # If of the form of `he-like` then convert
  splitArg <- num %>% strsplit(split = "-")
  if (splitArg %>% purrr::map(length) %>% purrr::flatten_dbl() %>% `>`(1)) {
    elementDetails <- splitArg %>%
      purrr::map(1) %>%
      purrr::flatten_chr() %>%
      stringr::str_to_title() %>%
      atomic::element_details(PT = PT)

    # Now get the difference in current element with like system
    num <- current - elementDetails$atomicNumber
    if (num < 0) stop(" ## Negative ions not permitted, check input.")
  }

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
