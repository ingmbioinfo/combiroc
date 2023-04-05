#' @title Compute a gene signature score for each cell of a scRNA-seq experiment
#' @description  Compute a signature score for each cell of a scRNA-seq experiment allowing to vizualize the expression of the whole signature in each cluster.
#' @details Given a geneset, this function computes a score for each cell which increases both when the number of expressed (>0) genes in the geneset increases, and when the expression of these genes increases.
#' This function replicates the code used to compute the "gene signature score" as described in Della Chiara, Gervasoni, Fakiola, Godano et al. 2021.
#' (https://www.nature.com/articles/s41467-021-22544-y)
#' @param SeuratObj a SeuratObject
#' @param geneset  a character containing a list of gene names
#' @param assay a character specifying the assay of interest
#' @return a data.frame with 5 columns:
#' - coexpression_score: count of how many genes of geneset are expressed in each cell
#' - expression_score: represents the overall expression of geneset genes for each cell
#' - combined_score: coexpression_score * expression_score
#' - scaled_combined_score: combined_score/max(combined_score)
#' - log_combined_score: 1/log10(combined_score)
#' @export

signature_score <- function(SeuratObj, geneset, assay='RNA'){
  
  # to discard lacking genes
  geneset <- geneset[geneset %in% rownames(SeuratObj[[assay]]@data)]
  # extracting the expression matrix
  raw.X <- SeuratObj[[assay]]@data
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
