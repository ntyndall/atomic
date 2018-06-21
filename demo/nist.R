# Load required libraries libraries
require(R.oo, quietly = T, warn.conflicts = F)
require(R.utils, quietly = T, warn.conflicts = F)
require(atomic, quietly = T, warn.conflicts = F)
require(magrittr, quietly = T, warn.conflicts = F)
require(crayon, quietly = T, warn.conflicts = F)

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

# Check for `element`
eExists <- ifelse(
  test = "element" %in% namedVariables,
  yes = T,
  no = F
)
if (!eExists) stop(crayon::red("Must supply -e flag"))

# Check for `overwrite`
oExists <- ifelse(
  test = "overwrite" %in% namedVariables,
  yes = T,
  no = F
)

if (!oExists) {
  INPUT$overwrite <- FALSE
  cat(crayon::yellow(" ## -o not provided, defaulting to FALSE \n"))
} else {
  INPUT$overwrite %<>% atomic::parse_overwrite()
}

# Check for `conversion`
cExists <- ifelse(
  test = "conversion" %in% namedVariables,
  yes = T,
  no = F
)

if (!cExists) {
  INPUT$conversion <- 'ev'
  cat(crayon::yellow(" ## -c not provided, defaulting to `ev` \n"))
} else {
  INPUT$conversion %<>% atomic::parse_conversion()
}

# Call main here
INPUT %>% atomic::main()

# End of the script
cat(crayon::green(' ## Script complete \n'))
