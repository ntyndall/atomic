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

# Call main function here
INPUT %>% atomic::nist()
