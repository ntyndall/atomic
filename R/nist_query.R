#' @title Get data
#'
#' @export

nist_query <- function(series) {
  series <- 'Co ii'
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

  return(response$content %>% rawToChar())
}
