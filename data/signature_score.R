# external function used to compute the "gene signature score" as described in
# Della Chiara, Gervasoni, Fakiola, Godano et al. 2021
# https://www.nature.com/articles/s41467-021-22544-y

signature_score <- function(SeuratObj, geneset){
  # extracting the expression matrix
  raw.X <- SeuratObj[["RNA"]]@data
  # counting how many genes of geneset are expressed in each cell
  count <- colSums(raw.X[geneset, ]>0)/length(geneset)
  # to quantify the overall expression of geneset genes for each cell
  exp <- colSums(raw.X[geneset,])/colSums(raw.X)
  # combining the 2 info and computing the score
  score <- count*exp
  # scale score and go to log
  scaled_score <- score/max(score)
  log_score <- 1/-log10(score)
  # creating a data.frame to store the scores
  df <- data.frame(matrix(0, ncol = 1, nrow = dim(raw.X)[2]))
  df$coexpression_score <- count
  df$expression_score <- exp
  df$combined_score <- score
  df$scaled_combined_score <- scaled_score
  df$log_combined_score <- log_score
  df[,1] <- NULL
  return(df)
}
