#' @title Check Input
#'
#' @description A function to check the provided input
#'  as a named list.
#'
#' @export



check_input <- function() {

  # Default values in the input list
  namedVariables <- INPUT %>%
    names

  # Start logging
  cat(crayon::blue(' -{ Checking command input \n'))

  # Check for `element`
  eExists <- ifelse(
    test = "element" %in% namedVariables,
    yes = T,
    no = F
  )

  if (!eExists) {
    stop(crayon::red("Must supply -e flag"))
  } else {
    cat(crayon::green("    ## Found -e flag :", INPUT$element, "\n"))
    INPUT$element %<>% atomic::parse_series()
  }

  # Check for `overwrite`
  oExists <- ifelse(
    test = "overwrite" %in% namedVariables,
    yes = T,
    no = F
  )

  if (!oExists) {
    INPUT$overwrite <- FALSE
    cat(crayon::yellow("    ## -o not provided, defaulting to FALSE \n"))
  } else {
    cat(crayon::green("    ## Found -o flag :", INPUT$overwrite, "\n"))
    INPUT$overwrite %<>% tolower %>% atomic::parse_overwrite()
  }

  # Check for `conversion`
  cExists <- ifelse(
    test = "conversion" %in% namedVariables,
    yes = T,
    no = F
  )

  if (!cExists) {
    INPUT$conversion <- 'ev'
    cat(crayon::yellow("    ## -c not provided, defaulting to `ev` \n"))
  } else {
    cat(crayon::green("    ## Found -c flag :", INPUT$conversion, "\n"))
    INPUT$conversion %<>% tolower %>% atomic::parse_conversion()
  }

  cat(crayon::blue("  }- \n\n"))

  # Return formatted input back
  return(INPUT)
}
