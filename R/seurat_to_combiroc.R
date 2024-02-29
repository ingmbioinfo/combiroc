#' @title Load CombiROC data.
#' @description  A function to extract a combiroc data (both labelled and unlabelled) from a SeuratObject.

#' @details By specifying a gene list (if the genes are in rownames of SeuratObject assay matrix, it subsets the gene expression matrix (@data) and it retreives their expression values. If a combiroc training dataset (labelled_data=T) is required, one or more categories of Idents(SeuratObject) must be selected as case_class, the others will be merged into control class.


#' @param SeuratObject Defines S4 classes for single-cell genomic data and associated information.
#' @param gene_list a list of gene names.
#' @param assay a character that specifies the assay of interest. 
#' @param labelled_data a boolean that specifies whether the combiroc data to be extracted must be labelled (with 'Class' column) or not.
#' @param case_class a character or a character vector specifying the category/ies to be considered as 'case class'. Required if labelled_data is TRUE.
#' @param case_label a character that will be assigned to the cells belonging to 'case class' category.
#' @param control_label a character that will be assigned to the cells belonging to 'control class' category.
#' @return a combiroc data.
#' @example R/examples/seurat_to_combiroc_example.R
#' @export

seurat_to_combiroc <- function(SeuratObject, gene_list, assay = 'RNA', labelled_data = FALSE, case_class = NA, 
                               case_label = 'case', control_label = 'control') {
  # Replace non-allowed characters in gene names
  replace_non_allowed_characters <- function(genes) {
    genes <- gsub('-', '_', genes)
    genes <- gsub('[.]', '_', genes)
    return(genes)
  }
  
  # Filter gene list based on SeuratObject
  valid_genes <- gene_list %in% rownames(SeuratObject[[assay]]@data)
  gene_list <- gene_list[valid_genes]
  if (!all(valid_genes)) {
    warning("Some genes in gene_list are not in SeuratObject. They have been omitted.")
  }
  
  # Extract and process expression data
  expression_data <- SeuratObject[[assay]]@data[gene_list, ]
  rownames(expression_data) <- replace_non_allowed_characters(rownames(expression_data))
  gene_list <- replace_non_allowed_characters(gene_list)
  gene_list <- sort(gene_list)
  CombiROC_data <- as.data.frame(t(as.matrix(expression_data)))
  CombiROC_data$ID <- rownames(CombiROC_data)
  
  # Handle labeled data
  if (labelled_data) {
    if ((any(is.na(case_class)) | length(case_class) == 0)|any(is.null(case_class))) {
      stop("case_class must be provided for labelled data")
    }
    CombiROC_data$Class <- ifelse(Seurat::Idents(SeuratObject) %in% case_class, case_label, control_label)
    
    # Finalize and return CombiROC data for labelled data
    CombiROC_data <- CombiROC_data[, c("ID", "Class", gene_list)]
  } else {
    # Finalize and return CombiROC data for unlabelled data
    CombiROC_data <- CombiROC_data[, c("ID", gene_list)]
  }
  
  rownames(CombiROC_data) <- 1:nrow(CombiROC_data)
  return(CombiROC_data)
}
