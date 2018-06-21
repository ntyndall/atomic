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
