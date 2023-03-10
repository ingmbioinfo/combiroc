
#'@title Classify data.frames using glm(link='binomial') models.
#'@description A function that applies the previously calculated models to an unclassified dataset and classifies the samples.
#'@details This function  can classify dataset loaded with load_unclassified_data() that MUST contain all the markers of the classified dataset used to train the models (the one loaded with load_data()).


#' @param unclassified_data a data.frame returned by load_unclassified_data().
#' @param Models a list of glm() objects returned by roc_reports().
#' @param Metrics a list of data.frame objects containing ROC metrics, returned by roc_reports().
#' @param Positive_class a numeric or a character that specifies the label of the samples that will be classified as positives
#' @param Negative_class a numeric or a character that specifies the label of the samples that will be classified as negatives
#' @param deal_NA a character that specifies how to treat missing values. With 'impute' NAs of each marker are substituted with the median of that given marker values. With 'remove' the whole observations containing a NA are removed'.
#' @return  a data.frame containing the predicted class of each sample, for each marker/combination in Models
#' @importFrom stats formula glm median predict quantile sd
#' @example R/examples/classify_example.R
#' @export

classify <- function(unclassified_data, Models, Metrics, Positive_class=1, Negative_class=0, deal_NA='impute'){


  if(deal_NA!='impute' & deal_NA!='remove'){
    stop('deal_NA must be "impute" or "remove"' )
  }

  if (sum(is.na(unclassified_data))>0){
    if(deal_NA=='impute'){
      id<- unclassified_data[,1]
      for (i in 2:dim(unclassified_data)[2]){
        unclassified_data[is.na(unclassified_data[,i]),i] <-median(unclassified_data[!is.na(unclassified_data[,i]),i])
      }
      warning('NAs have been substituted with median of markers values')
    }
    if(deal_NA=='remove'){
      for (i in 2:dim(unclassified_data)[2]){
        if (sum(is.na(unclassified_data)[,i])>0){
          unclassified_data <- unclassified_data[-which(is.na(unclassified_data[,i])),]
          id<- unclassified_data[,1]
          rownames(unclassified_data)<- 1:dim(unclassified_data)[1]
        }}
      warning('Observations with NAs were not been considered' )
    }
  }
  else{
    id<- unclassified_data[,1]

  }


  classification <- list()
  pr_df <- data.frame(id)
  colnames(pr_df)[1] <- 'ID'
  for (i in names(Models)){



    pred <- predict(Models[[i]], newdata = unclassified_data,
                    type = "response")
    cutoff <- Metrics[which(rownames(Metrics)==i), 4]

    pr_df[i] <- pred>cutoff
    pr_df[which(pr_df[i]=='TRUE'), i] <- Positive_class
    pr_df[which(pr_df[i]=='FALSE'), i] <- Negative_class
  }
  return(pr_df)}
