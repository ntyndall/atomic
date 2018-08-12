#' @title Get Arguments
#'
#' @description A function to gather and parse the arguments
#'  from command line input when running `Rscript`.
#'
#' @export


cl_arguments <- function() {

  # Create function for generating typical option lists
  create_option <- function(o, h, d, ty = 'character', de = NULL, me = 'character') {
    return(
      optparse::make_option(
        opt_str = o, type = ty, default = de, help = h, metavar = me, dest = d
      )
    )
  }

  # Create the bare option list
  optionList <- list(
    create_option(
      o = c("-e", "--element"),
      h = 'The element and series provided as {element}_{series} e.g. -e fe_ii',
      d = 'element'
    ),
    create_option(
      o = c("-o", "--overwrite"),
      h = 'Overwrite the file if it exists (defaults to false) e.g. -o true',
      d = 'overwrite'
    ),
    create_option(
      o = c("-c", "--conversion"),
      h = 'How to save the energy levels in the output (default to ev) e.g. -c ryd',
      d = 'conversion'
    ),
    create_option(
      o = c("-l", "--ls"),
      h = 'Return results in LS coupling (default to false) e.g. -l true',
      d = 'ls'
    )
  )

  # Read options
  optParser <- optparse::OptionParser(
    option_list = optionList,
    description = '\n Help options \n\n'
  )

  # Create the option list when running --help
  opt <- optParser %>%
    optparse::parse_args()

  # Return back the parser for further work
  return(optionList)
}

#' @title Args To List
#'
#' @export


args_to_list <- function(args, optionList) {
  inputNames <- values <- allOptions <- c()
  for (i in 1:length(optionList)) {
    options <- optionList[[i]]
    flags <- c(options@short_flag, options@long_flag)
    flagExists <- flags %in% args
    if (flagExists %>% any) {
      index <- flags[flagExists %>% which] %>% `==`(args) %>% which
      inputNames %<>% c(options@dest)
      values %<>% c(args[index + 1])
    }
  }
  inputVariables <- values %>% as.list
  names(inputVariables) <- inputNames
  return(inputVariables)
}
