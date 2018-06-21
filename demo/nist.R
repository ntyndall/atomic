# Load required libraries libraries
require(R.oo, quietly = T, warn.conflicts = F)
require(R.utils, quietly = T, warn.conflicts = F)
require(atomic, quietly = T, warn.conflicts = F)
require(magrittr, quietly = T, warn.conflicts = F)
require(crayon, quietly = T, warn.conflicts = F)

# Header text
cat(crayon::blue('\n Running script, results are saved in `/energylevels/` \n\n'))

# Create the option help list
optionList <- atomic::cl_arguments()

# Get the arguments
args <- R.utils::commandArgs(trailingOnly = TRUE)

# Check they are allowed and return as a named list
INPUT <- args %>%
  atomic::args_to_list(
    optionList = optionList
  )

# Default values in the input list
namedVariables <- INPUT %>%
  names

cat(crayon::blue(' -{ Checking command input \n'))

# Check for `element`
eExists <- ifelse(
  test = "element" %in% namedVariables,
  yes = T,
  no = F
)

if (!eExists) {
  stop(crayon::red("Must supply -e flag"))
} else {
  cat(crayon::green("    ## Found -e flag :", INPUT$element, "\n"))
  INPUT$element %<>% atomic::parse_series()
}

# Check for `overwrite`
oExists <- ifelse(
  test = "overwrite" %in% namedVariables,
  yes = T,
  no = F
)

if (!oExists) {
  INPUT$overwrite <- FALSE
  cat(crayon::yellow("    ## -o not provided, defaulting to FALSE \n"))
} else {
  cat(crayon::green("    ## Found -o flag :", INPUT$overwrite, "\n"))
  INPUT$overwrite %<>% tolower %>% atomic::parse_overwrite()
}

# Check for `conversion`
cExists <- ifelse(
  test = "conversion" %in% namedVariables,
  yes = T,
  no = F
)

if (!cExists) {
  INPUT$conversion <- 'ev'
  cat(crayon::yellow("    ## -c not provided, defaulting to `ev` \n"))
} else {
  cat(crayon::green("    ## Found -c flag :", INPUT$conversion, "\n"))
  INPUT$conversion %<>% tolower %>% atomic::parse_conversion()
}

cat(crayon::blue("  }- \n\n"))

# Call main here
cat(crayon::blue(" -{ Analysing data \n"))
INPUT %>% atomic::main()
cat(crayon::blue("  }- \n\n"))

# End of the script
cat("    ")
cat(crayon::blue("-{ Script complete }-\n"))
