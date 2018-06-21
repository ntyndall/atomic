#' @title Parse Response
#'
#' @export


parse_response <- function(content) {

  # Parse html text into an xml node
  htmlDoc <- content %>%
    xml2::read_html()

  # Get the actual content and get the nodes of content
  tBodyContent <- htmlDoc %>%
    xml2::xml_find_all(xpath = './/tbody')

  # Get the header names
  tableHeaders <- tBodyContent %>%
    `[`(1) %>%
    xml2::xml_children() %>%
    xml2::xml_children()

  # Get main header names
  textHeaders <- tableHeaders %>%
    xml2::xml_text() %>%
    strsplit(split = '[(]') %>%
    purrr::map(1) %>%
    stringr::str_trim(side = 'both')

  # Get spanning columns
  spanning <- tableHeaders %>%
    xml2::xml_attrs() %>%
    purrr::map('colspan') %>%
    purrr::map(function(x) if (x %>% is.null) 1 else x %>% as.integer) %>%
    as.integer

  # Create data frame headers
  dHeaders <- c(
    'Index',
    sapply(
      X = 1:(spanning %>% length),
      FUN = function(x) {
        if (spanning[x] == 1) textHeaders[x] else textHeaders[x] %>% paste0('-', 1:spanning[x])
      }
    ) %>%
      purrr::flatten_chr()
  )

  # Get the actual row data
  tableContent <- tBodyContent %>% `[`(2)

  # Define all the rows as children nodes from the body
  allRows <- tableContent %>%
    xml2::xml_children()

  # Initialise lastConf
  lastTerm <- lastConfig <- ''
  levels <- 0

  # Initialise data set
  totalData <- data.frame(stringsAsFactors = FALSE)

  # Set up progress bar
  pb <- utils::txtProgressBar(
    min = 0,
    max = allRows %>% length,
    style = 3
  )

  # Loop over all the table rows
  for (i in 1:(allRows %>% length)) {

    # Iterate progress bar
    pb %>% utils::setTxtProgressBar(
      value = i
    )

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

      # Have we hit the ionization limit yet?
      ionLimit <- if ('Limit' %in% elementContent) TRUE else FALSE

      if (!ionLimit) {
        # Find out which are just white space
        #filterElements <- sapply(
        #  X = elementContent,
        #  FUN = function(x) x %>% nchar %>% `>`(0)
        #) %>%
        #  as.logical

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

        #elementContent %<>% `[`(filterElements)
        #attrNames %>% `[`(filterElements)

        if (!confExists) {
          elementContent[1] <- currentConfig
          elementContent[2] <- currentTerm
        }

        singleRow <- c(levels, elementContent) %>%
          as.data.frame %>%
          t

        # Bind up the individual rows
        totalData %<>% rbind(singleRow)
      } else {
        ionInfo <- elementContent
      }
    }
  }

  # Name the column headers
  names(totalData) <- dHeaders

  # After looping through data, store everything
  results <- list(
    data = totalData,
    ion = ionInfo
  )
}
