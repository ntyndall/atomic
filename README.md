## Getting started
To install this package, run the following in R (or set up a .R script and run `Rscript install.R`)
```
install.packages('devtools')
library(devtools)
devtools::install_github('ntyndall/atomic')
```

## NIST data
To get well-prepared data from NIST in a human readable format, run the following from the root package;
```
Rscript demo/nist.R -e fe-ii
```
then the results are saved to `levels/fe-ii`. By running the command again, it will simply overwrite this file from the current NIST database.
