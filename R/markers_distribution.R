
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


markers_distribution <- function(data_long, min_SE=0, min_SP=0, x_lim=NULL, y_lim=NULL, boxplot_lim=NULL , signalthr_prediction=FALSE, case_class) {
Class <- data_long$Class
Values <- data_long$Values
Markers <- data_long$Markers

nclass <- unique(Class) # to retrieve the 2 classes

df <- data.frame(matrix(0, nrow = 2, ncol= 8))
rownames(df) <- nclass
colnames(df) <- c('# observations', 'Min', 'Max','Median', 'Mean', '1st Q.',  '3rd Q.', 'SD')


df <- data_long %>% group_by(Class) %>% summarise('# observations' = n(),
                                                  Min=min(Values),
                                                  Max=max(Values),
                                                  Median=median(Values),
                                                  Mean=mean(Values),
                                                  "1st Q"=quantile(Values,0.25),
                                                  "3rd Q"=quantile(Values,0.75),
                                                  SD=sd(Values))

if (is.null(boxplot_lim)){
  boxplot_lim= max(df$Max)*1.15
  warning('boxplot_lim is not set. Boxplot may be difficult to interpret due to outliers. You should set an appropriate y axis limit.')
}

Boxplot<- ggplot(data_long, aes(Markers, Values)) +
  geom_boxplot(aes(color = Class)) +
  theme_classic()+
  coord_cartesian(ylim = c(0,boxplot_lim)) # shows the boxplot for both classes


  if (min_SE==0 & min_SP==0){
    warning('In $Coord object you will see only the signal threshold values at which SE>=0 and SP>=0 by default. If you want to change this limits, please set min_SE and min_SP')
  }

  bin<- rep(NA, length(rownames(data_long)))
  for (i in 1:length(rownames(data_long))){
    if (Class[i] == case_class){bin[i] <- 1}
    else{bin[i] <- 0}}
  bin <- factor(bin)


  rocobj <-roc(Values, response=bin, levels=c("0","1"), quiet= TRUE)
  coord <- coords(rocobj)
  coord$Youden <- coord$specificity+coord$sensitivity - 1
  coord <- coord[coord$specificity>=min_SP/100 & coord$sensitivity>=min_SE/100, ]
  coord$specificity <- round(coord$specificity*100)
  coord$sensitivity <- round(coord$sensitivity*100)


  if (length(coord$threshold)==0){
    stop(' $Coord object is empty! No signal thresholds contained with SE >= min_SE  AND SP >= min_SP.')}


  if (is.null(x_lim)&is.null(y_lim)) {
    warning('You can adjust density plot zoom by setting y_lim and x_lim')
    p<- ggplot(data_long, aes(x=Values, color=Class)) +
      geom_density(n=10000) +
      theme_classic() }

  else if (is.null(x_lim)&!is.null(y_lim)) {
    p<- ggplot(data_long, aes(x=Values, color=Class)) +
      geom_density(n=10000) +
      theme_classic()+
      coord_cartesian(ylim = c(0, y_lim))}

  else if (!is.null(x_lim)&is.null(y_lim)) {
    p<- ggplot(data_long, aes(x=Values, color=Class)) +
      geom_density(n=10000) +
      theme_classic()+
      coord_cartesian(xlim = c(0, x_lim))}

  else  {
    p<- ggplot(data_long, aes(x=Values, color=Class)) +
      geom_density(n=10000) +
      theme_classic()+
      coord_cartesian(xlim = c(0, x_lim), ylim = c(0, y_lim))}

  if (isFALSE(signalthr_prediction)){
    res <- p+labs(x = "Signnal intensity", y="Frequency")
  }



  if (isTRUE(signalthr_prediction)){



    pr <- coord[coord$Youden==max(coord$Youden),'threshold'][1]
    warning('The suggested signal threshold in $Plot_density is the threshold with the highest Youden index of the signal thresholds at which SE>=min_SE and SP>=min_SP. This is ONLY a suggestion. Please check if signal threshold is suggested by your analysis kit guidelines instead, and remember to check $Plot_density to better judge our suggested threshold by inspecting the 2 distributions.')

    res <- p+geom_vline(aes(xintercept=pr),
                        color="black", linetype="dashed", size=0.5)+
      annotate("text", x = pr*0.50, y = 0, label =  as.character(round(pr,2)))+
      labs(x = "Signal intensity", y="Frequency")
    }

  robj <- list(res, coord, ggroc(rocobj, legacy.axes=TRUE), df, Boxplot)
  names(robj) <- c('Density_plot', 'Coord', 'ROC', 'Density_summary', 'Boxplot')
  return(robj)}
