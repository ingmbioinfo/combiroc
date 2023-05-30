
#'@title Compute the combi score using glm(link='binomial') models and optionally classifies the samples.
#'@description A function that applies the previously calculated models to a dataset to compute combi scores and optionally classify the samples.
#'@details This function  can take as input datasets loaded with load_data(). They MUST contain all the markers of the combinations used to train the models.


#' @param data a data.frame returned by load_data().
#' @param Models a list of glm() objects returned by roc_reports().
#' @param Metrics a list of data.frame objects containing ROC metrics, returned by roc_reports().
#' @param Positive_class a numeric or a character that specifies the label of the samples that will be classified as positives
#' @param Negative_class a numeric or a character that specifies the label of the samples that will be classified as negatives
#' @param deal_NA a character that specifies how to treat missing values. With 'impute' NAs of each marker are substituted with the median of that given marker values. With 'remove' the whole observations containing a NA are removed'.
#' @param classify a boolean that specifies if the samples will be classified.
#' @return  a data.frame containing the combi scores (classify=F) or predicted class of each sample (classify=T), for each marker/combination in Models
#' @importFrom stats formula glm median predict quantile sd
#' @example R/examples/combi_score_example.R
#' @export

  combi_score <- function(data, Models, Metrics, Positive_class=1, Negative_class=0, deal_NA='impute', classify=F){


  if(deal_NA!='impute' & deal_NA!='remove'){
    stop('deal_NA must be "impute" or "remove"' )
  }

  if (sum(is.na(data))>0){
    if(deal_NA=='impute'){
      id<- data[,1]
      for (i in 2:dim(data)[2]){
        data[is.na(data[,i]),i] <-median(data[!is.na(data[,i]),i])
      }
      warning('NAs have been substituted with median of markers values')
    }
    if(deal_NA=='remove'){
      for (i in 2:dim(data)[2]){
        if (sum(is.na(data)[,i])>0){
          data <- data[-which(is.na(data[,i])),]
          id<- data[,1]
          rownames(data)<- 1:dim(data)[1]
        }}
      warning('Observations with NAs were not been considered' )
    }
  }
  else{
    id<- data[,1]

  }


  pr_df <- data.frame(id)
  colnames(pr_df)[1] <- 'ID'
  for (i in names(Models)){



    pred <- predict(Models[[i]], newdata = data,
                    type = "response")
    cutoff <- Metrics[which(rownames(Metrics)==i), 4]

  if(isTRUE(classify)){
    pr_df[i] <- pred>cutoff
    pr_df[which(pr_df[i]=='TRUE'), i] <- Positive_class
    pr_df[which(pr_df[i]=='FALSE'), i] <- Negative_class
  }
  else{
    pr_df[i] <- pred
  }
  }
  return(pr_df)}
