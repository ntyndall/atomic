#' @title Get data
#'
#' @description A function that sends a post query to NIST to
#'  retrieve the HTTP response containing the level information
#'  in the form of a table, nested in an XML nodeset.
#'
#' @param series A character string containing an ionic series
#'  which is of the form \code{{Element} {Series}}, e.g. Co ii.
#'
#' @export


nist_query <- function(series, INPUT) {

  # Set up body args here
  bodyArgs <-  list(
    encodedlist = 'XXT2',
    spectrum = series,
    submit = 'Retrieve Data',
    units = INPUT$conversion %>% as.character,
    format = '0',
    output = '0',
    page_size = '15',
    multiplet_ordered = '0',
    conf_out = 'on',
    term_out = 'on',
    level_out = 'on',
    unc_out = '1',
    lande_out = 'on',
    perc_out = 'on',
    biblio = 'on',
    temp = ''
  )

  # If LS is false, add fine structure levels on
  if (INPUT$ls %>% `!`()) bodyArgs %<>% c(list(j_out = "on"))

  # Send POST request to NIST, all list information required.
  response <- httr::POST(
    url = 'https://physics.nist.gov/cgi-bin/ASD/energy1.pl',
    body = bodyArgs,
    encode = 'form'
  )

  # Return char response
  return(rawToChar(response$content))
}
