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
#' @import ggplot2 pROC stringr
#' @importFrom stats ave na.omit
#' @example R/examples/roc_reports_example.R
#' @export

roc_reports <- function(data, markers_table, selected_combinations = NULL, single_markers = NULL, case_class, deal_NA = 'impute') {
  if (!deal_NA %in% c('impute', 'remove')) {
    stop('deal_NA must be "impute" or "remove"')
  }
  
  # Handling missing values
  if (sum(is.na(data)) > 0) {
    if (deal_NA == 'impute') {
      for (i in 3:ncol(data)) {
        data[is.na(data[, i]), i] <- ave(data[, i], data$Class, FUN = function(x) median(x, na.rm = TRUE))
      }
      warning('NAs have been substituted with median of markers values')
    } else if (deal_NA == 'remove') {
      data <- na.omit(data)
      warning('Observations with NAs were not considered')
    }
  }
  
  cl<- data$Class
  
  # Binarize class
  data$Class <- factor(data$Class == case_class, levels = c(FALSE, TRUE), labels = c("0", "1"))
  
  roc_list <- list()
  model_list <- list()
  metrics_list <- list()
  
  # Prepare combinations
  selected_combinations <- if (!is.null(selected_combinations)) {
    lapply(selected_combinations, function(n){paste("Combination", as.character(n))})
  }
  selected_combinations<- if (!is.null(single_markers)) {
    c(single_markers, selected_combinations)
  }
  
  
  for (i in selected_combinations) {
    combination <- str_split(markers_table[i,"Markers"], "-")[[1]]
    formula_str <- paste("log(", combination, " + 1)", collapse = " + ")
    formula_str <- paste("Class ~", formula_str)
    
    model <- glm(formula_str, data = data, family = "binomial")
    model_list[[i]] <- model
    
    roc_obj <- roc(data$Class, model$fitted.values, levels = c("0", "1"), quiet = TRUE)
    roc_list[[i]] <- roc_obj
    
    opt_coords <- coords(roc_obj, "best", ret = c("threshold", "specificity",  "sensitivity", 
                                                  "accuracy","tn","tp", "fn", "fp", "npv", "ppv"))
    metrics_list[[i]] <- cbind(rownames(markers_table)[i], opt_coords, AUC = roc_obj$auc)
  }
  
  # Metrics DataFrame
  metrics_df <- do.call(rbind, metrics_list)
  metrics_df<- metrics_df[,-1]
  colnames(metrics_df)<-c("CutOff","SP","SE","ACC","TN","TP","FN","FP","NPV","PPV", "AUC")
  metrics_df <- metrics_df[,c("AUC","SE","SP","CutOff","ACC","TN","TP","FN","FP","NPV","PPV")]                                         
  
  
  # ROC Plot
  roc_plot <- ggroc(roc_list, legacy.axes = TRUE)
  
  data$Class<-cl
  
  list(Plot = roc_plot, Metrics = metrics_df, Models = model_list)
}



