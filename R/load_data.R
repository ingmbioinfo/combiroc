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

load_data <- function(data, sep = ";", na.strings="" , labelled_data=TRUE) {
  CombiROC_data <- read.table(data, header = TRUE, sep = sep ,
                              na.strings=na.strings)  # to load the data
  if(labelled_data==TRUE){
    class <- CombiROC_data[,2]
    CombiROC_data[,2] <- NULL
  }
  
  d <- CombiROC_data[, 2:dim(CombiROC_data)[2]]
  d <- d[, order(colnames(d))]
  CombiROC_data[,2:dim(CombiROC_data)[2]] <- d
  
  colnames(CombiROC_data)[2:dim(CombiROC_data)[2]] <- colnames(d)
  
  cond_list <- rep(NA, dim(CombiROC_data)[2]) # to initialize a list of
  # conditions to check for columns with expression values
  
  # checking the format ...
  for (i in 1:dim(CombiROC_data)[2]){
    cond_list[i] <- class(CombiROC_data[,i])=='numeric' | class(CombiROC_data[,i])=='integer'}
  # True if a column contains numbers
  
  if (length(unique(CombiROC_data[,1]))!=dim(CombiROC_data)[1]){stop('Values of 1st column must contain unique IDs!')}
  # fist column must have patients/samples IDs, they have to be unique.
  
  else if (sum(cond_list) != dim(CombiROC_data)[2]-1){stop('Values of markers columns must be numberic')}
  # number of numeric columns must be total number of columns -1
  
  else if (sum(str_detect(string =colnames(CombiROC_data), pattern = '-'))>0 ){
      colnames(CombiROC_data) <- str_replace_all(colnames(CombiROC_data), pattern = '-', '_')
      warning("'-' is not allowed in marker names, it will be replaced by '_'")
    }
  
  if(labelled_data==TRUE){
    CombiROC_data$Class <- class
    CombiROC_data<- CombiROC_data[,c(1, dim(CombiROC_data)[2], 3:dim(CombiROC_data)[2]-1 )] 
    if (isa(CombiROC_data[,2], what = 'character') == FALSE){stop('Values of 2nd column must be characters')}
    # second column must contain the class of the samples as characters
    else if (length(unique(CombiROC_data[,2]))!=2){stop('2nd column must contain 2 categories (e.g. Disease / Healthy)')}
    # only 2 categories are allowed
  }
    
    
    return(CombiROC_data)}


