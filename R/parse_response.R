#' @title Parse Response
#'
#' @export


parse_response <- function(content) {

  # Parse html text into an xml node
  htmlDoc <- content %>%
    xml2::read_html()

  # Get the actual content and get the nodes of content
  tBodyContent <- htmlDoc %>%
    xml2::xml_find_all(xpath = './/tbody') %>%
    `[`(2)

  # Define all the rows as children nodes from the body
  allRows <- tBodyContent %>%
    xml2::xml_children()

  # Initialise lastConf
  lastTerm <- lastConfig <- ''
  levels <- 0

  # Loop over all the table rows
  for (i in 1:(allRows %>% length)) {
    # Get the content of each row
    rowContent <- allRows[i] %>%
      xml2::xml_children()

    # Check that it all just isn't blank...
    lengthsOfContent <- rowContent %>%
      xml2::xml_text() %>%
      nchar

    # Check lengths
    if (lengthsOfContent %>% `==`(1) %>% all) {
      next
    } else {

      # Increment level count
      levels %<>% `+`(1)

      # Get attribute names first
      attrNames <- rowContent %>%
        xml2::xml_attrs() %>%
        as.character

      # Get all the element content
      elementContent <- rowContent %>%
        xml2::xml_text(trim = T)

      if ('Limit' %in% elementContent) ionLimit <- T

      # Find out which are just white space
      filterElements <- sapply(
        X = elementContent,
        FUN = function(x) x %>% nchar %>% `>`(0)
      ) %>%
        as.logical

      # Store what `could` be a configuration
      currentConfig <- elementContent[1]
      currentTerm <- elementContent[2]

      # Will need to search for s,p,d,f etc to pad a vector
      confExists <- currentConfig %>%
        grepl(pattern = '[[:alpha:]]')

      # Reassign last config / current config
      if (currentConfig == '') {
        currentConfig <- lastConfig
        currentTerm <- lastTerm
      } else {
        lastConfig <- currentConfig
        lastTerm <- currentTerm
      }

      elementContent %<>% `[`(filterElements)
      attrNames %>% `[`(filterElements)

      if (!confExists) elementContent <- c(currentConfig, currentTerm, elementContent)

      singleRow <- c(levels, elementContent)
      print(c(levels, elementContent))
    }
  }
}
