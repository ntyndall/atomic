#' @title Main
#'
#' @description A function that handles all the components of
#'  querying for data based on the input provided. Files and
#'  data are written from here.
#'
#' @param INPUT A named list contaning the input flags from
#'  running the script, INPUT can contain the following
#'    \itemize{
#'      \item{\code{element} : An element to query for e.g. fe ii}
#'      \item{\code{conversion} : One of ev / ryd / icm}
#'      \item{\code{overwrite} : TRUE or FALSE}
#'    }
#'
#' @importFrom magrittr %>% %<>%
#'
#' @export


main <- function(INPUT) {

  # Supply an element series to get the page content
  cat(crayon::green("    ## Sending query to NIST \n"))
  content <- INPUT$element %>%
    atomic::nist_query(
      INPUT = INPUT
    )

  # Parse the response and return a data frame of information
  cat(crayon::green("    ## Parsing content from NIST \n\n"))
  dataInfo <- content %>%
    atomic::parse_response()
  cat('\n\n')

  # Make sure the directory exists
  dirName <- getwd() %>%
    paste0('/energylevels')
  if (dirName %>% dir.exists %>% `!`()) dirName %>% dir.create

  # The file name
  fName <- INPUT$element %>%
    gsub(pattern = ' ', replacement = '_') %>%
    paste0('.csv')

  # Complete the full path
  fName <- dirName %>% paste0('/', fName)
  fNExist <- fName %>% file.exists %>% `!`()

  # Figure out whether to write the file or not and handle old files
  writeToFile <- if (fNExist) {
    TRUE
  } else {
    # The file exists here
    if (INPUT$overwrite) {
      fName %>% file.remove
      TRUE
    } else {
      cat(crayon::yellow("    ## File already exists, run again with -o true to overwrite this file. \n"))
      FALSE
    }
  }

  # Finally, write the file if necessary
  if (writeToFile) {
    dataInfo$data %>% write.csv(
      file = fName,
      row.names = FALSE
    )
    cat(crayon::green("    ## File written successfully. \n"))
  }

  # End of the script
  cat(crayon::blue("  }- \n\n    -{ Script complete }-\n"))
}
