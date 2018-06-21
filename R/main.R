#' @title Main
#'
#' @description A function that handles all the components of
#'  querying for data based on the input provided. Files and
#'  data are written from here.
#'
#' @export


main <- function() {

  # Test out ...
  currentSeries <- 'co ii'

  # Make sure the series is allowed
  currentSeries %>%
    atomic::series_checker()

  # Supply an element series to get the page content
  content <- currentSeries %>%
    atomic::nist_query()

  # Parse the response and return a data frame of information
  dataInfo <- content %>%
    atomic::parse_response()

  # Make sure the directory exists
  dirName <- getwd() %>%
    paste0('/energylevels')
  if (dirName %>% dir.exists %>% `!`()) dirName %>% dir.create

  # The file name
  fName <- currentSeries %>%
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
      cat(" ## File already exists, run again with -o true to overwrite this file. \n")
      FALSE
    }
  }

  # Finally, write the file if necessary
  if (writeToFile) {
    dataInfo$data %>% write.csv(
      file = fName,
      sep = ','
    )
  }
}
