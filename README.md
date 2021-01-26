
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oisst

<!-- badges: start -->
<!-- badges: end -->

The goal of `oisst` is to easily download [Optimum Interpolation Sea
Surface Temperature (OISST)](https://www.ncdc.noaa.gov/oisst) data
hosted by National Oceanic and Atmospheric Administration (NOAA).

## Installation

``` r
remotes::install_github("andybeet/oisst")
```

## Usage

To determine which years have data:

``` r
oisst::find_years()
#>  [1] "1981" "1982" "1983" "1984" "1985" "1986" "1987" "1988" "1989" "1990"
#> [11] "1991" "1992" "1993" "1994" "1995" "1996" "1997" "1998" "1999" "2000"
#> [21] "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010"
#> [31] "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019" "2020"
#> [41] "2021"
```

To download a single years data (year 2001 in example) into a folder
called “output” within your current directory

    oisst::get_oisst_data(years=2001,outputStructure=NULL,outputDir=here::here("output"))

To download years 2000, …, 2010 into yearly folders within the “output”
folder in current working directory:

    oisst::get_oisst_data(years=2000:2010,outputStructure="year",outputDir=here::here("output"))

To download years 2000, …, 2005 into a single folder within the “output”
folder in current working directory:

    oisst::get_oisst_data(years=2000:2005,outputStructure=NULL,outputDir=here::here("output"))

To download all data into monthly folders within the “output” folder in
current working directory:

    ooist::get_oisst_data(years=NULL,outputStructure="month",outputDir=here::here("output"))

#### Legal disclaimer

*This repository is a scientific product and is not official
communication of the National Oceanic and Atmospheric Administration, or
the United States Department of Commerce. All NOAA GitHub project code
is provided on an ‘as is’ basis and the user assumes responsibility for
its use. Any claims against the Department of Commerce or Department of
Commerce bureaus stemming from the use of this GitHub project will be
governed by all applicable Federal law. Any reference to specific
commercial products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce.
The Department of Commerce seal and logo, or the seal and logo of a DOC
bureau, shall not be used in any manner to imply endorsement of any
commercial product or activity by DOC or the United States Government.*
