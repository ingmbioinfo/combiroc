#' @title Show combinations with given markers.
#' @description  A function to find all the combinations containing all the markers of interest.

#' @param markers a character vector containing one or more markers of interest.
#' @param markers_table a data.frame with ranked combination, reporting: SE, SP, number of markers composing the combination and the score (returned by ranked_combs()).
#' @return a numeric vector containing the numbers corresponding to the combinations containing all the selected markers.
#' @example R/examples/combs_with_example.R
#' @export

combs_with<- function(markers, markers_table){
  mask <- rep(NA,dim(markers_table)[1])

  for (i in 1:dim(markers_table)[1]){
    mask[i] <- sum(str_count(markers_table[i,1], pattern = markers))==length(markers)
  }
  rownames(markers_table[mask,])
  combs <- as.numeric(gsub("Combination", "", rownames(markers_table[mask,])))
  if (length(combs)==0){
    warning('NO COMBINATION FOUND! Please check the selected markers')
  }

  message('The combinations in which you can find ALL the selected markers have been computed')

  return(combs)}
