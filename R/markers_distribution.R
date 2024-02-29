
#' @title  Show distribution of intensity values for all the markers both singularly and all together.


#' @description A function that takes as input data in long format, and shows how the signal intensity value of markers are distributed.
#' @details This function returns a named list containing the following objects:

#'  - “Density_plot”: a density plot showing the distribution of the signal intensity values for both the classes.
#'  - "Density_summary": a data.frame showing a summary statistics of the distributions.
#'  - “ROC”: a ROC curve showing how many real positive samples would be found positive (SE) and how many real negative samples would be found negative (SP) in function of signal threshold. NB: these SE and SP are refereed to the signal intensity threshold considering all the markers together; it is NOT equal to the SE/SP of a single marker/combination found with se_sp().
#'  - “Coord”: a data.frame that contains the coordinates of the above described “ROC” (threshold, SP and SE) that have at least a min SE (40 by default) and a min SP (80 by default).
#'  - "Boxplot": a boxplot showing the distribution of the signal intensity values of each marker singularly, for both the classes.
#'
#' In case of lack of a priori known threshold the user can set set signalthr_prediction= TRUE.
#' In this way the function provides a "suggested signal threshold" that corresponds to the median of the singnal threshold values (in "Coord") at which SE/SP are grater or equal to their set minimal values (min_SE and min_SP),
#' and it adds this threshold on the "Density_plot" object as a dashed black line.
#' The use of the median allows to pick a threshold whose SE/SP are not too close to the limits (min_SE and min_SP), but it is recommended to always inspect "Coord" and choose the most appropriate signal threshold by considering SP, SE and Youden index.

#' @param data_long a data.frame in long format returned by combiroc_long()
#' @param y_lim a numeric setting the max values of y that will be visualized in the density plot (zoom only, no data loss).
#' @param x_lim a numeric setting the max values of x that will be visualized in the density plot (zoom only, no data loss).
#' @param boxplot_lim a numeric setting the max values of y that will be visualized in the boxplot (zoom only, no data loss).
#' @param min_SE a numeric that specifies the min value of SE that a threshold must have to be included in $Coord.
#' @param min_SP a numeric that specifies the min value of SP that a threshold must have to be included in $Coord.
#' @param case_class a character that specifies which of the two classes of the dataset is the case class.
#' @param signalthr_prediction a boolean that specifies if the density plot will also show the "suggested signal threshold".
#' @return a named list containing 'Coord' and 'Density_summary' data.frames, and 'ROC', 'Boxplot' and 'Density_plot' plot objects.
#' @import ggplot2 pROC
#' @example R/examples/markers_distribution_example.R
#' @export

markers_distribution <- function(data_long, min_SE = 0, min_SP = 0, x_lim = NULL, y_lim = NULL, boxplot_lim = NULL, signalthr_prediction = FALSE, case_class) {
  # Preprocessing
  data_long <- na.omit(data_long)
  data_long$Class <- factor(data_long$Class, levels =unique(data_long$Class))
  Class<- data_long$Class
  Values<- data_long$Values
  Markers<- data_long$Markers
  bin <- as.numeric(data_long$Class == case_class)


  # Calculate summary statistics for each class
  density_summary <- do.call(rbind, by(data_long, data_long$Class, function(sub_data) {
    Observations <- nrow(sub_data)
    Min <- min(sub_data$Values)
    Max <- max(sub_data$Values)
    Median <- median(sub_data$Values)
    Mean <- mean(sub_data$Values)
    First_Quartile <- quantile(sub_data$Values, 0.25)
    Third_Quartile <- quantile(sub_data$Values, 0.75)
    SD <- sd(sub_data$Values)
    
    return(data.frame(Observations, Min, Max, Median, Mean, First_Quartile, Third_Quartile, SD))
  }))

  # Add row names as Class
  row.names(density_summary) <- levels(data_long$Class)

  
  # Boxplot
  boxplot_limit <- if (is.null(boxplot_lim)) max(density_summary$Max) * 1.15 else boxplot_lim
  boxplot <- ggplot(data_long, aes(x = Markers, y = Values)) +
    geom_boxplot(aes(color = Class)) +
    theme_classic() +
    coord_cartesian(ylim = c(0, boxplot_limit))
  
  # ROC Analysis
  roc_obj <- roc(response = bin, predictor = data_long$Values, levels = c("0", "1"), quiet = TRUE)
  coord <- coords(roc_obj, x = "all", input = "threshold", ret = c("threshold", "specificity", "sensitivity"))
  coord$Youden <- coord$sensitivity + coord$specificity - 1
  coord <- coord[coord$sensitivity >= min_SE / 100 & coord$specificity >= min_SP / 100, ]
  roc_plot <- ggroc(roc_obj, legacy.axes = TRUE)
  
  # Density Plot
  y_lim <- if (is.null(y_lim)) 1.15 else y_lim
  x_lim <- if (is.null(boxplot_lim)) max(density_summary$Max) * 1.15 else x_lim
  
  density_plot <- ggplot(data_long, aes(x = Values, color = Class)) +
    geom_density(n = 10000) +
    theme_classic() +
    coord_cartesian(xlim = c(0,x_lim), ylim = c(0,y_lim))
  if (signalthr_prediction) {
    suggested_threshold <- coord[which.max(coord$Youden), "threshold"]
    density_plot <- density_plot +
      geom_vline(xintercept = suggested_threshold, linetype = "dashed") +
      annotate("text", x = suggested_threshold, y = 0, label = round(suggested_threshold, 2))
  }
  
  # Return Results
  list(
    Density_plot = density_plot,
    Density_summary = density_summary,
    ROC = roc_plot,
    Coord = coord,
    Boxplot = boxplot
  )
}
                              