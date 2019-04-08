
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Build
Status](https://travis-ci.org/alan-y/objectremover.svg?branch=master)](https://travis-ci.org/alan-y/objectremover)
[![](https://cranlogs.r-pkg.org/badges/objectremover)](https://cran.r-project.org/package=objectremover)

# objectremover

`objectremover` is an RStudio addin to assist with clearing objects from
the Global environment. Features include removing objects by

  - Starting pattern of object name
  - Ending pattern of object name
  - Regular expression
  - Object type (dataframe, function and other)

## Installation

You can install the development version of `objectremover` from Github
with

``` r
devtools::install_github("alan-y/objectremover")
```

## Use

After installing the package, the add-in will be available in Rstudio
from the **Addins** dropdown menu. Select “Remove Objects” (under the
heading OBJECTREMOVER) from the menu to run.
