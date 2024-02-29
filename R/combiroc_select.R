#' @title Select Best Markers Using PCA
#' @description This function retrieves the best n markers of the dataset by training a logistic regression model with all the markers. It then performs Principal Component Analysis (PCA) to identify the most significant features in relation to the specified case class. The function ranks the markers by their weighted importance in the PCA and selects the top n markers.
#' @param data A data.frame returned by load_data().
#' @param case_class A character that specifies which of the two classes in the dataset is the case class.
#' @param n an integer specifying the number of top best markers to retain.
#' @param tol a value passed to prcomp(), indicating the magnitude below which principal components should be omitted. (Components are omitted if their standard deviations are less than or equal to tol times the standard deviation of the first component.) See stats::prcomp documentation. 
#' @return a list containing: "PCA" the result of stats::prcomp() and "best_markers" a named numeric vector with marker names as names their importance in distinguishing the case class.
#'@param n_cpus an integer that specifies the number of cores to allocate.
#'@import parallel
#' @importFrom stats prcomp glm cor
#' @example R/examples/combiroc_select_example.R
#' @export

combiroc_select <- function(data, case_class, n_cpus=NULL, n=NULL, tol=0.1) {
  # Ensure data has 'Class' column
  if (!"Class" %in% colnames(data)) {
    stop("Data must contain 'Class' column.")
  }
  cat('Feature selection with',n_cpus, 'physical CPUs')
  # Prepare data
  class_vector <- as.numeric(data$Class == case_class)
  X <- data[, -c(1,2)]
  
  # Apply PCA
  pca_result <- prcomp(X, center=TRUE, scale. = TRUE, tol=tol )
  cat(ncol(pca_result$x),"PCs have been computed with 'tol'=", tol)
  # Set up parallel backend to use multiple cores
  n_cpus <- if (is.null(n_cpus)){ceiling(detectCores(logical = FALSE) /4)} else{n_cpus}
 
  cl <- makeCluster(n_cpus)
  clusterExport(cl, varlist = c("pca_result", "class_vector"), envir=environment())

  # Calculate correlations between PCs and class in parallel
  pc_correlations <- parSapply(cl, 1:ncol(pca_result$x), function(i) {
    cor(pca_result$x[,i], class_vector)
  })

  # Calculate weighted importance of original features in parallel
  loadings <- pca_result$rotation

  clusterExport(cl, varlist = c("loadings", "pc_correlations"),  envir=environment())
  weighted_importance <- parApply(cl, loadings, 1, function(x) sum(x * pc_correlations))

  # Order features by weighted importance and select top n
  if (is.null(n)){n<- dim(X)[2]}
  weighted_importance <- sort(weighted_importance, decreasing = TRUE)[1:n]

  # Stop parallel backend
  stopCluster(cl)
    
  list(
  PCA = pca_result,
  best_markers = weighted_importance
  )                                

}
