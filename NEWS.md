# combiroc 0.3.4 - July 4, 2023

This version is aimed at CRAN submission: small edits and variations were made to make it pass the R-CMD-check --as-cran testing, and presubmission CRAN checks have been solved.

Please note that (differently from previous CRAN release) the `min_SE` and `min_SP` arguments of `markers_distribution()` function have now a default value = 0. This means that no threshold values are imposed to SE or SP to be included in the data.frame that contains the coordinates of the above computed ROC.  
Thus if the user does not set up any threshold, all SE and SP values are taken into account.

# combiroc 0.3.3 - July 1, 2023

* modified load_data() function for code consistency in checking classes of samples' labels
* all unnecessary (leftover) dependencies were eliminated
* modified disrupting URLs in readme and vignettes
* precomputed objects of vignette 2 were moved out of package and referenced for download
* tarball size of source package was reduced
* made some stylistic edits in vignettes
* solved other minor bugs 

# combiroc 0.3.1 - June 28, 2023

Minor changes for vignette knitting consistency and smaller bugs on dependencies. Namespace and demo datasets related problems were solved. Documentation consistency between package and second version of preprint was checked and further enforced.

# combiroc 0.3.0 - June 12, 2023

This version of combiroc package enforces the full-fledge single cell RNAseq workflow. The scRNAseq workflow vignette has been thoroughly expanded and updated. This version is synchronized with the most updated version of the biorXiv preprint (the "less is more" version)

* New functions were added for data interoperability between combiroc and Seurat single-cell package
* se_sp() function was removed. SE and SP are directly calculated during combinatorial analysis
* New Seurat-style demo data was added
* Streamlined combi_score() function for model finding
* Bugs and minor changes throughout the package

# combiroc 0.2.3 - Aug. 13, 2021

This version of combiroc package is the quasi-stable version ready for CRAN submission

* Final version of vignette with clarified text and examples
* Minor tweaks on titles and descriptions throughout the documentation
* Solved build errors on R development version for windows and ubuntu
* Removed unnecessary raw data files from data and test folders
* Performed build checks via Travis
* Increased code coverage from tests

# combiroc 0.2.2 - Aug. 12, 2021

* Significant restructuring of the guide (vignette), added more unit testing, checked for code coverage and a number of minor misspellings.

# combiroc 0.2.1 - Aug. 10, 2021

* Minor tweaks on descriptions, hex logo and vignette readability, in preparation for major release

# combiroc 0.2.0 - Aug. 8, 2021

* This is still a development version passing all R-CMD-checks --as-cran. Unit tests on functions have been added for continuous development. This is to be considered the package's first usable version.

# combiroc 0.1.0 - July 2021

* First public release of the development version. Package is fully functional but under active development and still prone to be heavily modified.
