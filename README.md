
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Soil Frost and Snow Pits Dashboard

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install the development version of `{soildash}` like so:

``` r
remotes::install_github("kale-23/soil_dashboard", dependencies = TRUE)
#> Downloading GitHub repo kale-23/soil_dashboard@HEAD
#> xml2     (1.4.1 -> 1.5.1) [CRAN]
#> testthat (3.3.0 -> 3.3.1) [CRAN]
#> Installing 2 packages: xml2, testthat
#> Installing packages into '/private/var/folders/7m/cw5svscs5nl009_t2t82ghl00000gp/T/Rtmp4P3O9C/temp_libpath62fc70131e'
#> (as 'lib' is unspecified)
#> 
#> The downloaded binary packages are in
#>  /var/folders/7m/cw5svscs5nl009_t2t82ghl00000gp/T//RtmpQfcVIf/downloaded_packages
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘/private/var/folders/7m/cw5svscs5nl009_t2t82ghl00000gp/T/RtmpQfcVIf/remotes1f7dc6c360b/Kale-23-soil_dashboard-2df6e9d/DESCRIPTION’ ... OK
#> * preparing ‘soildash’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Omitted ‘LazyData’ from DESCRIPTION
#>   NB: this package now depends on R (>= 4.1.0)
#>   WARNING: Added dependency on R >= 4.1.0 because package code uses the
#>   pipe |> or function shorthand \(...) syntax added in R 4.1.0.
#>   File(s) using such syntax:
#>     ‘fct_plot_setup.R’ ‘fct_reactive_data_connection.R’ ‘mod_gen_ui.R’
#> * building ‘soildash_1.0.tar.gz’
#> Installing package into '/private/var/folders/7m/cw5svscs5nl009_t2t82ghl00000gp/T/Rtmp4P3O9C/temp_libpath62fc70131e'
#> (as 'lib' is unspecified)
```

## Run

You can launch the application by running:

``` r
soildash::run_app()
```

## About

You are reading the doc about version : 1.0

This README has been compiled on the

``` r
Sys.time()
#> [1] "2026-01-07 12:28:27 EST"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading soildash
#> ── R CMD check results ─────────────────────────────────────── soildash 1.0 ────
#> Duration: 9.8s
#> 
#> ❯ checking DESCRIPTION meta-information ... WARNING
#>   Non-standard license specification:
#>     What license is it under?
#>   Standardizable: FALSE
#> 
#> ❯ checking top-level files ... NOTE
#>   Non-standard file/directory found at top level:
#>     ‘restart.txt’
#> 
#> ❯ checking dependencies in R code ... NOTE
#>   Namespace in Imports field not imported from: ‘lisa’
#>     All declared Imports should be used.
#> 
#> ❯ checking R code for possible problems ... NOTE
#>   mod_gen_server : <anonymous>: no visible binding for global variable
#>     ‘site_name’
#>   prepare_plot_data: no visible binding for global variable ‘site_name’
#>   prepare_plot_data: no visible global function definition for ‘all_of’
#>   prepare_plot_data: no visible binding for global variable ‘water_year’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘form_response_time’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘sampler_email’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘sampler_initials’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘sampling_date’
#>   reactive_poll_connection : <anonymous>: no visible global function
#>     definition for ‘everything’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘site_name’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘swe’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘albedo’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘avg_snow_depth’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘avg_shallow_frost_depth’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘avg_max_frost_depth’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘avg_thaw_depth’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘surface_temperature_celsius’
#>   reactive_poll_connection : <anonymous>: no visible binding for global
#>     variable ‘snow_depth_centimeters’
#>   Undefined global functions or variables:
#>     albedo all_of avg_max_frost_depth avg_shallow_frost_depth
#>     avg_snow_depth avg_thaw_depth everything form_response_time
#>     sampler_email sampler_initials sampling_date site_name
#>     snow_depth_centimeters surface_temperature_celsius swe water_year
#> 
#> 0 errors ✔ | 1 warning ✖ | 3 notes ✖
#> Error:
#> ! R CMD check found WARNINGs
```
