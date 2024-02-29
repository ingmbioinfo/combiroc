#' @title Provide statistics for each marker.
#' @description A function that computes the statistics and a scatter-plot for each marker.
#' @details This function computes the main statistics of the signal values distribution of each marker in both classes. In addition, it also shows the values through scatter plots.
#' @param data_long a data.frame in long format returned by combiroc_long().
#' @return a list object containing:
#' - 'Statistics': a dataframe containing the main statistics for each marker in each class.
#' - 'Plots': a named list of scatter plots showing signal intensity values.
#' @importFrom data.table setDT
#' @importFrom ggplot2 ggplot aes geom_point labs scale_x_discrete
#' @importFrom moments skewness
#' @example R/examples/single_markers_statistics_example.R
#' @export

single_markers_statistics <- function(data_long) {
  
  # Convert data_long to a data.table
  setDT(data_long)
  
  # Rename first column to 'ID' if not already named
  setnames(data_long, old = names(data_long)[1], new = 'ID')
  
  Values<-data_long$Values
  Markers<- data_long$Markers
  Class<- data_long$Class
  ID<- data_long$ID
  
  # Compute statistics for each marker and class
  stats_df <- data_long[, list(
    Mean = mean(Values),
    Min = min(Values),
    Max = max(Values),
    Sd = sd(Values),
    CV = sd(Values) / mean(Values),
    First_Quart = quantile(Values, probs = 0.25),
    Median = median(Values),
    Third_Quart = quantile(Values, probs = 0.75),
    Skewness = skewness(Values)
  ), by = list(Markers, Class)]
  
  # Initialize an empty list for plots
  plot <- vector("list", length(unique(data_long$Markers)))
  markers <- unique(data_long$Markers)
  
  # Generate scatter plots for each marker
  for (i in seq_along(markers)) {
    plot[[i]] <- ggplot(data_long[Markers == markers[i]], aes(x = ID, y = Values)) +
      geom_point(aes(color = Class)) +
      labs(title = markers[i], x = "Samples") +
      scale_x_discrete(labels = NULL, breaks = NULL)
  }
  names(plot) <- markers
  
  # Combine statistics and plots in a list
  res <- list(Statistics = stats_df, Plots = plot)
  return(res)
}

