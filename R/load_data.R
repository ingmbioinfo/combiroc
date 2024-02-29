#' @title Load CombiROC data.
#' @description A customized read.table() function that checks the conformity of the dataset format, and only if all checks are passed, loads it.

#' @details The dataset to be analysed should be in text format, which can be comma, tab or semicolon separated:

#' - The 1st column must contain patient/sample IDs as characters.
#' - If dataset is labelled, the 2nd column must contain the class to which each sample belongs.
#' - The classes must be exactly 2 and they must be written in character format.
#' - From the 3rd column on (2nd if dataset is unlabelled), the dataset must contain numerical values that represent the signal corresponding to the markers abundance in each sample (marker-related columns).
#' - Marker-related columns can be called 'Marker1, Marker2, Marker3, ...' or can be called directly with the gene/protein name, but "-" is not allowed in the column name.

#' Only if all the checks are passed, it reorders alphabetically the marker-related columns depending on marker names (necessary for a proper computation of combinations), and it forces "Class" as 2nd column name.

#' @param data the name of the file which the data are to be read from.
#' @param sep the field separator character.
#' @param na.strings a character vector of strings which are to be interpreted as NA values.
#' @param labelled_data a boolean that specifies whether the combiroc data to be loaded is labelled (with 'Class' column) or not.
#' @return a data frame (data.frame) containing a representation of the data in the file.
#' @importFrom utils read.table
#' @example R/examples/load_data_example.R
#' @export

load_data <- function(data, sep = ";", na.strings = "", labelled_data = TRUE) {
  CombiROC_data <- read.table(data, header = TRUE, sep = sep, na.strings = na.strings)
  
  # Check for unique IDs in the first column
  if (!all(table(CombiROC_data[, 1]) == 1)) {
    stop("Values of the first column must contain unique IDs!")
  }
  
  # Replace non-allowed characters in column names
  colnames(CombiROC_data) <- str_replace_all(colnames(CombiROC_data), pattern = '-', '_')
  if (sum(str_detect(string = colnames(CombiROC_data), pattern = '-')) > 0) {
    warning("'-' is not allowed in marker names, it has been replaced by '_'")
  }
  
  # Check for numeric columns (excluding the first one and potentially the second one)
  marker_columns <- if (labelled_data) 3:ncol(CombiROC_data) else 2:ncol(CombiROC_data)
  if (!all(sapply(CombiROC_data[, marker_columns], is.numeric))) {
    stop("Values of marker columns must be numeric")
  }
  markers<- colnames(CombiROC_data)[marker_columns]
   # Handle labelled data
  if (labelled_data) {
    if (!is.character(CombiROC_data[, 2])) {
      stop("Values of the second column must be characters for labelled data")
    }
    if (length(unique(CombiROC_data[, 2])) != 2) {
      stop("Second column must contain exactly 2 categories (e.g., Disease / Healthy)")
    }
    # Ensure "Class" is the second column name
    names(CombiROC_data)[2] <- "Class"
    
    # Reorder columns alphabetically
    CombiROC_data <- CombiROC_data[, c(1, 2,order(markers)+2)]
    
  }
  else{
    # Reorder columns alphabetically
    CombiROC_data <- CombiROC_data[, c(1, order(markers)+1)]
  }
  
  
  return(CombiROC_data)
}
