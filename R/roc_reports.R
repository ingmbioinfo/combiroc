#' @title Train logistic regression and compute ROC.
#' @description A function to compute General Linear Model (binomial) and the corresponding ROC curves for each selected combination.
#' @details This function trains a logistic regression model for each combination and returns a named list containing 3 objects:

#' - "Plot": a ggplot object with the ROC curves of the selected combinations.
#' - "Metrics": a data.frame with the metrics of the roc curves (AUC, opt. cutoff, etc ...).
#' - "Models": the list of models (glm() objects) that have been computed and then used to classify the samples (in which you can find the model equation for each selected combination).

#' @param data a data.frame returned by load_data().
#' @param markers_table a data.frame with combinations and corresponding positive samples counts, obtained with combi().
#' @param single_markers a character vector that specifies the single markers of interest.
#' @param selected_combinations a numeric vector that specifies the combinations of interest.
#' @param case_class a character that specifies which of the two classes of the dataset is the case class.
#' @param deal_NA a character that specifies how to treat missing values. With 'impute' NAs of each marker are substituted with the median of that given marker values in the class that observation belongs to. With 'remove' the whole observations containing a NA are removed'.
#' @return a named list containing 3 objects: "Plot", "Metrics" and "Models".
#' @import dplyr ggplot2 pROC stringr
#' @example R/examples/roc_reports_example.R
#' @export

roc_reports <- function(data, markers_table, selected_combinations=NULL, single_markers=NULL, case_class, deal_NA='impute'){
  # to binarize $Class

  if(deal_NA!='impute' & deal_NA!='remove'){
    stop('deal_NA must be "impute" or "remove"' )
  }

  if (sum(is.na(data))>0){
    if(deal_NA=='impute'){
      for (i in 3:dim(data)[2]){
        data[is.na(data[,i]) & data$Class==case_class,i] <-median(data[!is.na(data[,i]) & data$Class==case_class,i])
        data[is.na(data[,i]) & data$Class!=case_class,i] <-median(data[!is.na(data[,i]) & data$Class!=case_class,i])
      }
      warning('NAs have been substituted with median of markers values')
    }
    if(deal_NA=='remove'){
      for (i in 3:dim(data)[2]){
        if (sum(is.na(data[,i]))>0){
        data <- data[-which(is.na(data[,i])),]
        rownames(data)<- 1:dim(data)[1]
      }}
      warning('Observations with NAs were not been considered' )
    }
  }

  bin<- rep(NA, dim(data)[1])
  for (i in 1:dim(data)[1]){
    if (data$Class[i] == case_class){bin[i] <- 1}
    else{bin[i] <- 0}}
  bin <- factor(bin)
  data$Class <- bin

  tab <- markers_table

  roc_list <- list() # It will contain ROC objects
  model_list <- list()



  if (is.null(selected_combinations)){
    for (i in 1:length(single_markers)){
    single_markers[i] <- which(rownames(markers_table)== single_markers[i])}
    sc<- as.numeric(single_markers)}

  if (!is.null(selected_combinations)){
    if (is.null(single_markers)){
    sc<- selected_combinations + (length(colnames(data))-2)}

    if (!is.null(single_markers)){
      sc<- selected_combinations + (length(colnames(data))-2)
      for (i in 1:length(single_markers)){
        single_markers[i] <- which(rownames(markers_table)== single_markers[i])}
    sc <- as.numeric(union(single_markers,sc))}}


  AUC <- rep(0, length(sc))

  # 0s dataframe to be filled
  perfwhole <-  data.frame(matrix(0, ncol = 10, nrow = length(sc)))


  # for each combination
  for ( i in sc){
    m <-str_split(tab$Markers[i],"-") # extract single markers from combination
    # for each composing marker
    for (x in m){
      y <- paste("log(",x,"+1)",sep="")} # partial formula

    str <- paste(y, collapse = '+')
    fla <- formula(paste("Class ~",str)) # whole formula

    model_list[[which(sc==i)]]<- glm(fla,data=data, family="binomial")
    names(model_list)[which(sc==i)] <- rownames(tab)[i]

    # storing the ROC object by naming it with the corresponding combination
    roc_list[[which(sc==i)]]<-roc(data$Class,model_list[[which(sc==i)]]$fitted.values,levels=c("0","1"), quiet= TRUE)
    names(roc_list)[which(sc==i)] <- rownames(tab)[i]


    # retrieving metrics
    optcoordinates<-coords(roc_list[[which(sc==i)]], "best", ret=c("threshold", "specificity",  "sensitivity", "accuracy","tn",
                                                                   "tp", "fn", "fp", "npv", "ppv"))



    # adding a row containing a combination metrics to perfwhole dataframe
    perfwhole[which(sc==i),] <- optcoordinates[1,]

    rownames(perfwhole)[which(sc==i)] <- rownames(tab)[i]

    AUC[which(sc==i)] <- roc_list[[which(sc==i)]]$auc[1]
  }
  colnames(perfwhole)<-c("CutOff","SP","SE","ACC","TN","TP","FN","FP","NPV","PPV")
  perfwhole <- mutate(perfwhole, AUC = AUC)
  perfwhole <- perfwhole[,c(11,3,2,1,4,5,6,7,8,9,10)]

  p <- ggroc(roc_list, legacy.axes=T)
  res<-list(p,round(perfwhole,3), model_list)

  names(res) <- c('Plot', 'Metrics', 'Models')

  return(res)}


