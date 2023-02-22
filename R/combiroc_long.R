
#' @title Reshape combiroc data in long format.
#' @description A function that simply wraps dyplr::pivot_longer() to reshape data in long format without taking into account NAs.
#' @details This function returns the data in long format (with 'Markers' and 'Values' columns)
#' @param data a data.frame returned by load_data().
#' @return a data.frame in long format
#' @import stringr
#' @importFrom tidyr pivot_longer
#' @example R/examples/combiroc_long_example.R
#' @export

combiroc_long <- function(data){
  data_long <- pivot_longer(data, cols =  3:dim(data)[2], names_to = "Markers", values_to = "Values")
  data_long <- data_long[!is.na(data_long$Values), ]

  return(data_long)
}

