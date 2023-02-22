#' @title Compute combinations.
#' @description A function that computes the marker combinations and counts their corresponding positive samples for each class (once thresholds are selected).
#' @details This function counts how many samples are 'positive' for each combination. A sample, to be considered positive for a given combination, must have a value higher than a given signal threshold (signalthr) for at least a given number of markers composing that combination (combithr).
#'@param data a data.frame returned by load_data().
#'@param signalthr a numeric that specifies the value above which a marker expression is considered positive in a given sample. Since the target of the analysis is the identification of marker combinations capable to correctly classify samples, the user should choose a signalthr that:

#' - Positively selects most samples belonging to the case class, which must be above signalthr.
#' - Negatively selects most control samples, which must be below signalthr.
#'@param combithr a numeric that specifies the necessary number of positively expressed markers (>= signalthr), in a given combination, to cosinder that combination positivelly expressed in a sample.
#'@param case_class a character that specifies which of the two classes of the dataset is the case class
#'@param max_length an integer that specifies the max combination length that is allowed
#'@return a data.frame containing how many samples of each class are "positive" for each combination, sensitivity and specificity.
#'@import gtools
#'@example R/examples/combi_example.R
#'@export


combi <-function(data,signalthr=0, combithr=1, max_length=NULL, case_class){

  nclass <- unique(data$Class) # to retrieve the 2 classes
  control_class<- nclass[nclass!=case_class]

  #sample df to get names and dims
  dfe <- data[data$Class== nclass[1], 3:dim(data)[2]]
  dfe<-t(dfe)
  n_features<-length(rownames(dfe))

  markers <- as.factor(rownames(dfe))

  # parameters for combinations
  if (is.null(max_length)){max_length <- n_features}

  k<- 1:max_length

  l <- array(0, dim = c(1, length(markers)))
  for (i in k){ l[i]<- dim(combinations(length(markers), i, markers))[1]}
  K <- sum(l)
  ### list of all possible combinations
  listCombinationMarkers <- array(0,dim=c(K,1))

  ### relative frequency for each class  (the row numbers depend on the K possible combinations while the column numbers depends on the number classes:2 (class A and class B, pairwise comparison))
  frequencyCombinationMarkers<-array(0,dim=c(K,2))

  # COMPUTING COMBINATIONS AND FREQUENCIES
  index<-1

  for (i in 1:length(k)){
    temp<- combinations(n_features,k[i],rownames(dfe))
    # storing the row index to calculate the relative frequency
    row_index_combination<-combinations(n_features,k[i])
    for (j in 1:dim(temp)[1]){
      listCombinationMarkers[index,1]<-paste(temp[j,],collapse="-")
      ## single antigen
      if(dim(temp)[2]==1){ ## 1 antigen combination
        for (n in 1:length(nclass)){
          frequencyCombinationMarkers[index,n]<-length(which(
            t(data[data$Class== nclass[n], 3:dim(data)[2]])[row_index_combination[j,],]>=signalthr))    #input$signalthr
        }
      }else{ ## more than 1 antigen (combination)
        for (n in 1:length(nclass)){
          frequencyCombinationMarkers[index,n]<- length(which((colSums(
            t(data[data$Class== nclass[n], 3:dim(data)[2]])[row_index_combination[j,],]>=signalthr))>=combithr))   #input$signalthr))>=input$combithr
        }}
      index<-index+1
    }}

  # only single markers

  if (max_length==1){
    cdf <- data.frame(listCombinationMarkers, frequencyCombinationMarkers)
    colnames(cdf) <- c('Markers', paste0('#Positives ', nclass[1]), paste0('#Positives ', nclass[2]))
    for (i in 1:n_features){
      rownames(cdf)[i] <- cdf[i,1]
    }
  }


  # makers + combinations
  if (max_length>1){

  # creation of the dataframe with combinations and corresponding frequencies
  cdf <- data.frame(listCombinationMarkers, frequencyCombinationMarkers)
  colnames(cdf) <- c('Markers', paste0('#Positives ', nclass[1]), paste0('#Positives ', nclass[2]))
  for (i in 1:n_features){
    rownames(cdf)[i] <- cdf[i,1]
  }
  for (j in (n_features+1):K){
    rownames(cdf)[j] <- paste('Combination', as.character(j-n_features) )
  }
  }
  cdf$SE <- 100*(cdf[, paste0('#Positives ', case_class)] / sum(data$Class==case_class))
  cdf$SP <- 100-(100*(cdf[,paste0('#Positives ', control_class)] / sum(data$Class==control_class)))
  cdf$n_markers <- as.double(lapply(cdf$Markers, function(x) str_count(x, pattern = "-")+1))

  return(cdf)}
