#' @title Parse Response
#'
#' @export


parse_response <- function(content) {

  htmlDoc <- content %>% xml2::read_html()

  tBodyContent <- htmlDoc %>%
    xml2::xml_find_all(xpath = './/tbody') %>%
    `[`(2)

  allRows <- tBodyContent %>% xml2::xml_children()

  for (i in 1:(allRows %>% length)) {
    # Get the content of each row
    rowContent <- allRows[i] %>%
      xml2::xml_children()

    # Check that it all just isn't blank...
    lengthsOfContent <- rowContent %>%
      xml2::xml_text() %>%
      nchar

    if (lengthsOfContent %>% `==`(1) %>% all) {
      next
    } else {
      # Get attribute names first
      attrNames <- rowContent %>%
        xml2::xml_attrs() %>%
        as.character

      # Get all the element content
      elementContent <- rowContent %>%
        xml2::xml_text(trim = T)

      # Find out which are just white space
      filterElements <- sapply(
        X = elementContent,
        FUN = function(x) x %>% nchar %>% `>`(0)
      ) %>% as.logical

      # Will need to search for s,p,d,f etc to pad a vector
      confExists <- elementContent[1] %>%
        grepl(pattern = '[[:alpha:]]')

      elementContent %<>% `[`(filterElements)
      attrNames %>% `[`(filterElements)

      if (!confExists) elementContent <- c(" ", elementContent)

      print(elementContent)
    }
  }
}
