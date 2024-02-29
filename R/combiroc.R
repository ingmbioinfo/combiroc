#' Taming Combinations of Biomarkers
#' @description Easily and Powerfully Calculates Specificity, Sensitivity and ROC Curves of Biomarkers Combinations. In the following sections there is a brief summary of the package content.
#'
#'
#' @section data loading and reshaping:
#'
#' - load_data(): to check and load data.
#' - load_unclassified_data(): to check and load unclassified data.
#' - combiroc_long(): to reshape data in long format.
#'
#' @section distribution inspection:
#'
#' - markers_distribution(): to show distribution of intensity values for all the markers both singularly and all together.
#'
#' @section combinatorial analysis:
#'
#' - combi(): to compute marker combinations.
#' - se_sp(): to compute sensitivity and specificity of each combination.
#' - ranked_combs(): to rank combinations.
#'
#' @section logistic regression training and fitting:
#'
#' - roc_reports(): to train logistic regression and compute ROC.
#' - classify(): to apply the previously calculated models to an unclassified dataset and classifies the samples.
#'
#' @section  markers/combinations correspondence:
#'
#' - show_markers(): to show the composition of combinations
#' - combs_with(): to show all combinations with given markers.

#' @section  built-in demo datasets:
#'
#' - demo_data: proteomics data from Zingaretti et al. 2012 - PMC3518104)
#' - demo_unclassified_data: dataset obtained by randomly picking 20 samples from demo_data without their classification.
#' - demo_seurat: #' A subset of the pbmc3k.SeuratData::pbmc3k.final object containing only the following genes 'RBP7','CYP1B1','CD14','FCN1','NKG7' and 'GNLY'
#' @docType package
#' @name combiroc
NULL
#> NULL
