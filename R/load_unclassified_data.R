#' @title Load unclassified data.
#' @description  A function to load datasets not yet classified. It's analogue to load_data() since it loads the same data type and performs the same format checks, with the exception of "Class" column that in unclassified data is missing.

#' @details  The unclassified dataset to be loaded should be in text format, which can be comma, tab or semicolon separated:

#' - The 1st column must contain unique patient/sample IDs.
#' - From the 2nd column on, the dataset must contain numerical values that represent the signal corresponding to the markers abundance in each sample (marker-related columns).
#' - Marker-related columns must be called with the same name of the dataset previously loaded with load_data().
#' Only if all the checks are passed, it reorders alphabetically the marker-related columns depending on marker names (necessary for a proper computation of combinations), and it forces "Class" as 2nd column name.

#' @param data the name of the file which the data are to be read from.
#' @param sep the field separator character.
#' @param na.strings a character vector of strings which are to be interpreted as NA values.
#' @return a data frame (data.frame) containing a representation of the data in the file.
#' @importFrom utils read.table
#' @example R/examples/load_unclassified_data_example.R
#' @export

load_unclassified_data <- function(data, sep = ";", na.strings="" ) {

  unclassified_data <- read.table(data, header = TRUE, sep = sep ,
                                  na.strings=na.strings)  # to load the data

  cond_list <- rep(NA, dim(unclassified_data)[2]) # to initialize a list of
  # conditions to check for columns with expression values
  cond_list1 <- rep(NA, dim(unclassified_data)[2]) # to initialize a list of
  # conditions to check for columns with expression values

  # checking the format ...
  for (i in 1:dim(unclassified_data)[2]){
    cond_list[i] <- class(unclassified_data[,i])=='numeric' | class(unclassified_data[,i])=='integer'
    cond_list1[i] <- str_detect(colnames(unclassified_data)[i],"-")}
  # True if a column contains numbers

  if (length(unique(unclassified_data[,1]))!=dim(unclassified_data)[1]){stop('Values of 1st column must contain unique IDs!')}
  # fist column must have patients/samples IDs, they have to be unique


  else if (sum(cond_list) != dim(unclassified_data)[2]-1){stop('Values from 2nd column on must be numbers')}
  # number of numeric columns must be total number of columns -1

  else if (sum(cond_list1) >= 1){stop('"-" is not allowed in column names')}

  else{ # if it's ok
    # reordering marker columns alphabetically - necessary to properly compute combinations later
    d <- unclassified_data[, 2:dim(unclassified_data)[2]]
    d <- d[, order(colnames(d))]
    unclassified_data[,2:dim(unclassified_data)[2]] <- d

    colnames(unclassified_data)[2:dim(unclassified_data)[2]] <- colnames(d)
    return(unclassified_data)}}

