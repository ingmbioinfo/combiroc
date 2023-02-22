#' @title Show the composition of combinations.
#' @description  A function to show the composition of combinations of interest.
#' @param markers_table a data.frame with combinations returned by combi().
#' @param selected_combinations a numeric vector that specifies the combinations of interest.
#' @return a data.frame containing the selected combinations and their composing markers.
#' @example R/examples/show_markers_example.R
#' @export

show_markers <- function(markers_table, selected_combinations){
  df<- data.frame(matrix(0, ncol=2, nrow=length(selected_combinations)))
  combo_list <- list()
  markers_list <- list()
  for (i in 1:length(selected_combinations)){
    combo_list[i]<- paste('Combination',  as.character(selected_combinations[i]))
    df[i,1] <- combo_list[[i]]
    markers_list[i] <- markers_table[which(rownames(markers_table)==combo_list[i]), 1]
    df[i,2] <- markers_list[[i]]
  }
  colnames(df) <- c('Combination', 'Composing_markers')

  return(df)}

