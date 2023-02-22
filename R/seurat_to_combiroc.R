#' @title Load CombiROC data.
#' @description  A function to extract a combiroc data (both labelled and unlabelled) from a SeuratObject.

#' @details By specifying a gene list (if the genes are in rownames of SeuratObject assay matrix, it subsets the gene expression matrix (@data) and it retreives their expression values. If a combiroc training dataset (labelled_data=T) is required, one or more categories of Idents(SeuratObject) must be selected as case_class, the others will be merged into control class.
           

#' @param SeuratObject Defines S4 classes for single-cell genomic data and associated information.
#' @param gene_list a list of gene names.
#' @param assay a character that specifies the assay of interest. 
#' @param labelled_data a boolean that specifies whether the combiroc data to be extracted must be labelled (with 'Class' column) or not.
#' @param case_class a character or a character vector specifing the category/ies to be considered as 'case class'. Required if labelled_data is TRUE.
#' @param case_label a character that will be assigned to the cells belonging to 'case class' category.
#' @param control_label a character that will be assigned to the cells belonging to 'control class' category.
#' @return a combiroc data.
#' @example R/examples/seurat_to_combiroc_example.R
#' @export

seurat_to_combiroc <- function(SeuratObject, gene_list, assay='RNA', labelled_data=F, case_class=NA, 
                               case_label='case', control_label='control') {

    gene_list<- gene_list[gene_list %in% rownames(SeuratObject[[assay]])]
    gene_list <- gene_list[order(gene_list)]
    CombiROC_data <- data.frame(t(data.frame(SeuratObject[[assay]]@data[gene_list,])))
    CombiROC_data$ID <- rownames(CombiROC_data)
    CombiROC_data <- CombiROC_data[,c('ID', gene_list)]
    rownames(CombiROC_data) <- 1:dim(CombiROC_data)[1]
    if(labelled_data){
        CombiROC_data$Class <- lapply(Seurat::Idents(SeuratObject), function(x){x %in% case_class})
        CombiROC_data$Class[CombiROC_data$Class==T] <- case_label
        CombiROC_data$Class[CombiROC_data$Class==F] <- control_label
        CombiROC_data$Class <- as.character(CombiROC_data$Class)
        CombiROC_data <- CombiROC_data[,c('ID', 'Class',gene_list)]
    }
    return(CombiROC_data)}

