#' A demo dataset with proteomics markers
#'
#' Combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104). A dataset containing signal intensity values of a 5-marker signatures for Autoimmune Hepatitis (AIH). Samples have been clinically diagnosed as “abnormal” (class A) or "normal" (class B).
#'
#'
#' @format A data frame with 170 rows and 7 variables:
#' \describe{
#'   \item{Patient.ID}{the ID of samples}
#'   \item{Class}{the class of the samples: A-Healthy, B-AIH}
#'   \item{Marker1}{the signal intensity value of Marker1}
#'   \item{Marker2}{the signal intensity value of Marker2}
#'   \item{Marker3}{the signal intensity value of Marker3}
#'   \item{Marker4}{the signal intensity value of Marker4}
#'   \item{Marker5}{the signal intensity value of Marker5}
#' }
#' @example R/examples/demo_data_example.R
"demo_data"