## Getting started
To install this package, run the following in R
```r
install.packages('devtools')
library(devtools)
devtools::install_github('ntyndall/atomic')
```
or from the command line,
```sh
Rscript -e "install.packages('devtools'); library(devtools); devtools::install_github('ntyndall/atomic')"
```

## Collecting energy levels from NIST
To get well-prepared data from NIST in a human readable format, run the following from the root package;
```sh
Rscript demo/nist.R -e fe ii
```
then the results are saved to `energylevels/fe_ii.csv`.

This is the bare minimum to get going, however there are a few other useful commands;
  - `-e` (element) : A character string, space separated element to query for, **must** always be supplied
    - Elements can be supplied as `fe` / `iron` / `IrOn` (case-insensitive)
    - Series can be supplied as `0` / `2` / `3+` / `ii` / `vi` / `li-like` (case-insensitive also)
  - `-o` (overwrite) : A boolean `true` or `false` which is default to `false` and allows overwriting files.
  - `-c` (conversion) : A character string of `ev` / `ryd` / `icm`, defaults to `ev` (case-insensitive).

If in doubt, always refer to 
```sh
Rscript demo/nist.R --help
```
for a full list of available options. If something goes wrong however, the standard output should be verbose enough to figure out what went wrong.
