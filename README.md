<img src="man/figures/combiroc.png" align="right" alt="" width="120" />

<!-- badges: start -->
[![pages-build-deployment](https://github.com/ingmbioinfo/combiroc/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/ingmbioinfo/combiroc/actions/workflows/pages/pages-build-deployment)
[![Lifecycle:experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental-1)
[![](https://img.shields.io/github/last-commit/ingmbioinfo/combiroc.svg)](https://github.com/ingmbioinfo/combiroc/commits/master)
[![Codecov test coverage](https://codecov.io/gh/ingmbioinfo/combiroc/branch/master/graph/badge.svg)](https://codecov.io/gh/ingmbioinfo/combiroc?branch=master)
<!-- badges: end -->

# Combiroc

The combiroc package is a totally new music in multi-markers analysis: an R package for efficient and easy combinatorial selection of biomarkers and sensitivity/specificity-driven prioritization of features. 

Latest version introduces new features to work __on single-cell RNAseq datasets__ too, selecting smaller markers sub-signatures that can be used to efficiently identify and annotate cell clusters. 

This is the development version of CombiROC package (combiroc), code in this repo is work in progress and it is uploaded here "as-is" with no warranties implied. Improvements and new features will be added on a regular basis, please check on this github page for new features and releases. 

The CombiROC approach was first released as a Shiny Application with limited features, which is still available at [combiroc.eu](http://combiroc.eu/), but it has limited features as well as low computational power and is __not further maintained__. If you need to cite the method or the web-app please refer to [**Mazzara et al.** Scientific Reports 2017](https://www.nature.com/articles/srep45477) and [**Bombaci & Rossi**, Methods Mol Biol 2019](https://link.springer.com/protocol/10.1007%2F978-1-4939-9164-8_16).

For full capabilities and customized analyses we suggest to install the combiroc package from  [CRAN](https://cloud.r-project.org/web/packages/combiroc/index.html); for the new and improved single-cell workflow features you need to install the latest development version from this repo (see below). 

In any case, if you are using the combiroc **package** in your research, please cite our **_"Less is more"_ bioRxiv preprint**: [**Ferrari et al.** *Combiroc: when 'less is more' in bulk and single cell marker signatures*. bioRxiv 2022.01.17.476603; doi: https://doi.org/10.1101/2022.01.17.476603](https://www.biorxiv.org/content/10.1101/2022.01.17.476603v2) 

## Combiroc bioRxiv preprint Supplementary material

The [bioRxiv](https://www.biorxiv.org/content/10.1101/2022.01.17.476603v1) preprint's Supplementary Material 1 and 2 can be accessed here:  

* __Supplementary Material 1__ (Standard vignette): [Standard worlkflow](https://ingmbioinfo.github.io/combiroc/articles/combiroc_vignette_1.html). 
* __Supplementary Material 2__ (Additional vignette): [scRNAseq workflow](https://ingmbioinfo.github.io/combiroc/articles/combiroc_vignette_2.html). 


## Installation

```r
# You can install combiroc pulling it from CRAN:
install.packages("combiroc")
```
### Development version

```r
# To install the most recent development version from this repository install "remotes" first:
install.packages("remotes")
library(remotes)
# remotes is a lightweight replacement of install functions from devtools
# if you already have devtools, you can also use devtools::install_github() 

# Then install the development version of CombiROC:
remotes::install_github("ingmbioinfo/combiroc", 
                        dependencies = TRUE, build_vignettes = TRUE)
```

## Full Documentation - Tutorial

Full documentation is in the package's vignette. You can also find the rendered version of the vignette in the [combiroc-package website](https://ingmbioinfo.github.io/combiroc/index.html) created with `pkgdown`.

## Quick start example

```r
library(combiroc)

# load the preformatted demo dataset
# (you can load a dataset of yours using load_data() function: see full docs)
data <- demo_data

# shape it in long format (prone to plotting)
data_long <- combiroc_long(data)

# study the distribution of you markers' signal
# arguments values to be adjusted according to  data
distr <- markers_distribution(data_long, case_class = 'A', 
                              y_lim = 0.0015, x_lim = 3000, 
                              signalthr_prediction = TRUE, 
                              min_SE = 40, min_SP = 80, 
                              boxplot_lim = 2000)

# explore the distr object: boxplot of signals
distr$Boxplot

# explore the distr object: densities of classes with signal threshold (signalthr)
distr$Density_plot
distr$Density_summary

# explore the distr object: ROC and its coordinates
distr$ROC
head(distr$Coord, n=10)

# combinatorial analysis, indicatinf case class anf for combinations of up to 3 markers:
tab <- combi(data, signalthr = 328, combithr = 1,
             case_class = "A", max_length = 3)

# ranked combinations              
rmks <- ranked_combs(tab, min_SE = 40, min_SP = 80)

# check ranked combinations
rmks$table
rmks$bubble_chart

# results report for specific markers/combinations
reports <-roc_reports(data, markers_table = tab, case_class = 'A',
                      single_markers =c('Marker1'), 
                      selected_combinations = c(11,15))

# results outputs
reports$Plot
reports$Metrics
```

## Issues - Bugs

If you find a bug, or to share ideas for improvement, feel free to [start an issue](https://github.com/ingmbioinfo/combiroc/issues). We do have a roadmap but we also listen!

## Contributors

* Package authors and maintainers: Ivan Ferrari & Riccardo L. Rossi
* Original code of Shiny App: Saveria Mazzara
* Initial idea & conception: Mauro Bombaci

## Trivia

We were so happy to finally had the chance to develop the combiroc package that we felt very "rock": this is why the combiroc hexagon sticker logo is a homage to [Eddie Van Halen](https://en.wikipedia.org/wiki/Eddie_Van_Halen) who left us in 2020, and the "Frankenstrat", his [iconic guitar](https://en.wikipedia.org/wiki/Frankenstrat). 

