#' @title Provide statistics for each marker.
#' @description A function that computes the statistics and a scatter-plot for each marker.
#' @details This function computes the main statistics of the signal values distribution of each marker in both classes. In addition it also shows the values through scatter plots.
#'@param data_long a data.frame in long format returned by combiroc_long().
#'@return a list object containing:
#'- 'Statistics': a dataframe containing the main statistics for each marker in each class.
#'- 'Plots': a named list of scatter plots showing signal intensity values.
#'@import dplyr ggplot2 moments
#'@example  R/examples/single_markers_statistics_example.R
#'@export


single_markers_statistics <- function(data_long){

markers <- unique(data_long$Markers)
Markers <- data_long$Markers
Class <- data_long$Class
Values <- data_long$Values
colnames(data_long)[1] <- 'ID'
ID <- data_long$ID





stats<- data_long %>%
    group_by(Markers, Class) %>%
    summarize(Mean = mean(Values),
              Min = min(Values),
              Max = max(Values),
              Sd = sd(Values),
              CV = sd(Values)/mean(Values),
              First_Quart. = quantile(Values)[2],
              Median = median(Values),
              Third_Quart. = quantile(Values)[4],
              Skewness = skewness(Values))

plot <- list()

for (i in 1:length(markers)){
  plot[[i]] <-  ggplot(data_long[data_long$Markers==markers[i],],aes(x= ID, y=Values)) +
  geom_point(aes(color=Class)) +
  labs(title=markers[i], x ="Samples") +
  scale_x_discrete(labels = NULL, breaks = NULL)

}
names(plot) <- markers

res <- list(stats, plot)
names(res) <- c('Statistics', 'Plots')
return(res)
}
