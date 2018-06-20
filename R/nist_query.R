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


nist_query <- function(series) {

  # Send POST request to NIST, all list information required.
  response <- httr::POST(
    url = 'https://physics.nist.gov/cgi-bin/ASD/energy1.pl',
    body =
      list(
        encodedlist = 'XXT2',
        spectrum = series,
        submit = 'Retrieve Data',
        units = '0',
        format = '0',
        output = '0',
        page_size = '15',
        multiplet_ordered = '0',
        conf_out = 'on',
        term_out = 'on',
        level_out = 'on',
        unc_out = '1',
        j_out = 'on',
        lande_out = 'on',
        perc_out = 'on',
        biblio = 'on',
        temp = ''
      ),
    encode = 'form'
  )

  # Return char response
  return(rawToChar(response$content)) 
}
