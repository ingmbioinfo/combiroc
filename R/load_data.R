#' @title Load CombiROC data.
#' @description A customized read.table() function that checks the conformity of the dataset format, and only if all checks are passed, loads it.

#' @details The dataset to be analysed should be in text format, which can be comma, tab or semicolon separated:

#' - The 1st column must contain patient/sample IDs as characters.
#' - The 2nd column must contain the class to which each sample belongs.
#' - The classes must be exactly 2 and they must be written in character format.
#' - From the 3rd column on, the dataset must contain numerical values that represent the signal corresponding to the markers abundance in each sample (marker-related columns).
#' - Marker-related columns can be called 'Marker1, Marker2, Marker3, ...' or can be called directly with the gene/protein name, but "-" is not allowed in the column name.

#' Only if all the checks are passed, it reorders alphabetically the marker-related columns depending on marker names (necessary for a proper computation of combinations), and it forces "Class" as 2nd column name.

#' @param data the name of the file which the data are to be read from.
#' @param sep the field separator character.
#' @param na.strings a character vector of strings which are to be interpreted as NA values.
#' @return a data frame (data.frame) containing a representation of the data in the file.
#' @importFrom utils read.table
#' @example R/examples/load_data_example.R
#' @export

load_data <- function(data, sep = ";", na.strings="" ) {

  CombiROC_data <- read.table(data, header = TRUE, sep = sep ,
                              na.strings=na.strings)  # to load the data

  names(CombiROC_data)[2] <- ('Class')  #  to force the name of 2nd column as
  # 'Class'

  cond_list <- rep(NA, dim(CombiROC_data)[2]) # to initialize a list of
  # conditions to check for columns with expression values
  cond_list1 <- rep(NA, dim(CombiROC_data)[2]) # to initialize a list of
  # conditions to check for columns with expression values

  # checking the format ...
  for (i in 1:dim(CombiROC_data)[2]){
    cond_list[i] <- class(CombiROC_data[,i])=='numeric' | class(CombiROC_data[,i])=='integer'
    cond_list1[i] <- str_detect(colnames(CombiROC_data)[i],"-")}
  # True if a column contains numbers

  if (length(unique(CombiROC_data[,1]))!=dim(CombiROC_data)[1]){stop('Values of 1st column must contain unique IDs!')}
  # fist column must have patients/samples IDs, they have to be unique.

  else if (class(CombiROC_data[,2])!= 'character'){stop('Values of 2nd column must be characters')}
  # second column must contain the class of the samples as characters

  else if (length(unique(CombiROC_data[,2]))!=2){stop('2nd column must contain 2 categories (e.g. Disease / Healthy)')}
  # only 2 categories are allowed

  else if (sum(cond_list) != dim(CombiROC_data)[2]-2){stop('Values from 3rd column on must be numbers')}
  # number of numeric columns must be total number of columns -2

  else if (sum(cond_list1) >= 1){stop('"-" is not allowed in column names')}
  # number of numeric columns must be total number of columns -2

  else{ # if it's ok
    # reordering marker columns alphabetically - necessary to properly compute combinations later
    d <- CombiROC_data[, 3:dim(CombiROC_data)[2]]
    d <- d[, order(colnames(d))]
    CombiROC_data[,3:dim(CombiROC_data)[2]] <- d

    colnames(CombiROC_data)[3:dim(CombiROC_data)[2]] <- colnames(d)
    return(CombiROC_data)}}


