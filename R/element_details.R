#' @title Element Details
#'
#' @description A function to check whether an element is
#'  in the periodic table or not.
#'
#' @export


element_details <- function(currentElement, PT) {
  # All possible element combinations
  allElements <- c(PT$symbol %>% as.character, PT$element %>% as.character) %>%
    stringr::str_trim(side = 'right')

  # Check if either format exists + return back the symbol
  if (currentElement %in% allElements) {
    index <- currentElement %>%
      `==`(allElements) %>%
      which %>%
      `%%`(PT %>% nrow)
    elementDetails <- PT[index, ]
  } else {
    stop(" ## Element provided by -e not found.")
  }

  # Return the element details
  return(elementDetails)
}
