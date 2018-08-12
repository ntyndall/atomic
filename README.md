## Getting started
To install this package, run the following in R
```r
install.packages('devtools')
library(devtools)
devtools::install_github('ntyndall/atomic')
```
or from the command line,
```shell
Rscript -e "install.packages('devtools', repos = 'https://cloud.r-project.org/'); library(devtools); devtools::install_github('ntyndall/atomic')"
```

## Usage - Collecting energy levels from NIST 
#### Method 1
To get well-prepared data from NIST in a human readable format, run the following from the root package;
```shell
Rscript demo/nist.R -e fe_ii
```
then the results are saved to `energylevels/Fe_ii.csv`.

This is the bare minimum to get going, however there are a few other useful commands;
  - `-e` (**element**) : A character string, underscore separated element to query for, **must** always be supplied
    - Elements can be supplied as `fe` / `iron` / `IrOn` (case-insensitive)
    - Series can be supplied as `0` / `2` / `3+` / `ii` / `vi` / `li-like` (case-insensitive also)
  - `-o` (**overwrite**) : A boolean `true` or `false` which is default to `false` and allows overwriting files.
  - `-c` (**conversion**) : A character string of `ev` / `ryd` / `icm`, defaults to `ev` (case-insensitive).
  - `-l` (**ls**) : A boolean `true` or `false` which is default to `false` and allows switching between LS coupling and FS.

If in doubt, always refer to 
```shell
Rscript demo/nist.R --help
```
for a full list of available options. If something goes wrong however, the standard output should be verbose enough to figure out what the issue is.

#### Method 2
If you do not want to clone the repo, you can use an inbuilt function from the package to supply a list of variables. Using the example from Method 1, try running from any directory;
```shell
Rscript -e "library(atomic); atomic::nist(list(element = 'fe_ii', overwrite = TRUE))"
```
You can supply the same, named arguments as above in Method 1 that are in bold, and this will place all the results into `energylevels/Fe_ii.csv` also.
