#' @title Compute combinations.
#' @description A function that computes the marker combinations and counts their corresponding positive samples for each class (once thresholds are selected).
#' @details This function counts how many samples are 'positive' for each combination. A sample, to be considered positive for a given combination, must have a value higher than a given signal threshold (signalthr) for at least a given number of markers composing that combination (combithr).
#'@param data a data.frame returned by load_data().
#'@param signalthr a numeric that specifies the value above which a marker expression is considered positive in a given sample. Since the target of the analysis is the identification of marker combinations capable to correctly classify samples, the user should choose a signalthr that:

#' - Positively selects most samples belonging to the case class, which must be above signalthr.
#' - Negatively selects most control samples, which must be below signalthr.
#'@param combithr a numeric that specifies the necessary number of positively expressed markers (>= signalthr), in a given combination, to cosinder that combination positivelly expressed in a sample.
#'@param case_class a character that specifies which of the two classes of the dataset is the case class
#'@param n_cores an integer that specifies the number of cores to allocate.
#'@param max_length an integer that specifies the max combination length that is allowed.
#'@return a data.frame containing how many samples of each class are "positive" for each combination, sensitivity and specificity.
#'@import gtools parallel stringr data.table
#'@importFrom utils combn
#'@example R/examples/combi_example.R
#'@export



combi <- function(data, signalthr = 0, combithr = 1, max_length = NULL, n_cores=NULL, case_class) {
  
  # Extract column names as marker names starting from the 3rd column
  markers <- colnames(data)[3:ncol(data)]
  
  # If max_length is not specified, set it to the total number of markers
  if (is.null(max_length)) {
    max_length <- length(markers)
  }

  # Generate all combinations of markers up to max_length
  combination_list <- unlist(lapply(combithr:max_length, function(k) {
    combn(markers, k, simplify = FALSE)
  }), recursive = FALSE)
    

  # Convert each combination of markers to a string separated by hyphens
  combination_list <- lapply(combination_list, function(x){paste(x, collapse = "-")})
    
  # Convert input data to data.table for efficient processing
  dt <- as.data.table(data)
  # Create binary 'Case' and 'Control' columns based on 'Class' column and case_class
  dt$Case <- dt$Class == case_class
  dt$Control <- dt$Class != case_class
  
  n_cores <- if (is.null(n_cores)){ceiling(detectCores(logical = FALSE) /4)} else{n_cores}
 
  cat('Computing all the combinations up to',max_length, 'markes with', n_cores, ' physical CPUs')

  # Set up parallel processing using the specified number of cores
  cl <- makeCluster(n_cores)
  clusterExport(cl, varlist = c("dt", "combination_list","signalthr", "combithr"), envir=environment())
  clusterEvalQ(cl, library(data.table))
  clusterEvalQ(cl, library(stringr))

  # Process each marker combination in parallel
  results <- parLapply(cl, combination_list, function(combination) {
    # Split the combination string into individual markers
    s_combination <- str_split(combination, '-')[[1]]
    # Find column indices of the markers in data
    marker_indices <- match(s_combination, markers) + 2
    
    # Subset data for Case and Control groups
    case_data <- dt[dt$Case, marker_indices, with=FALSE]
    control_data <- dt[dt$Control, marker_indices, with=FALSE]

    # Calculate sum of markers >= signalthr for each row
    TPM <- rowSums(as.data.table(case_data) >= signalthr, na.rm = TRUE)
    FPM <- rowSums(as.data.table(control_data) >= signalthr, na.rm = TRUE)
    # Count positives based on combithr threshold
    case_positives <- sum(TPM >= combithr)
    control_positives <- sum(FPM >= combithr)
      
    # Create a summary data.table
    res <- data.table(Markers=combination, 
                      TP=case_positives, FP=control_positives, 
                      SE=100 * (case_positives / sum(dt$Case)),
                      SP=100 - (100 * (control_positives / sum(dt$Control))), 
                      n_markers=length(s_combination))
    
    # Return the result
    return(res)
  })
    
    

  
  # Stop the parallel cluster
  stopCluster(cl)
    
  # Combine all results into one data frame
  cdf <- rbindlist(results)
  cdf <- as.data.frame(cdf)
  
  # Creating the data.frame for discarded combinations (length(combination) < combithr)
  if (combithr>1){
      cat("Combinations with length < 'combithr' (",combithr,") have a sensitivity of 0, as they cannot be expressed by definition. See the 'combithr' parameter in the documentation for more information")
      
     discarded <- unlist(lapply(1:(combithr-1), function(k) { combn(markers, k, simplify = FALSE)}), recursive = FALSE)
     discarded_list <- lapply(discarded, function(x){paste(x, collapse = "-")})
     disc <- as.data.frame(matrix(0, nrow = length(discarded), ncol = 6))
     colnames(disc)<- colnames(cdf)
     disc$Markers<- discarded_list
     disc$SP <- 100
     disc$n_markers <- lapply(discarded, length)
     cdf <- rbind(disc, cdf)
  }
  # Assign row names
  rownames(cdf) <- lapply(1:dim(cdf)[1], function(n) { paste('Combination', as.character(n-length(markers)))})
  rownames(cdf)[1:(length(markers))] <- markers
  return(cdf)
}