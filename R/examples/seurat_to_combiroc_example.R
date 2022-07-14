library(Seurat)
library(SeuratData)
library(SeuratDisk)

pbmc3k.final # PBMC3K dataset from Satijia et al. 2015

# list of markers of interest
gene_list<-c('RBP7','CYP1B1','CDA', 'CD14','FCN1','SERPINA1','BST1','C5AR1','LYZ')

# to extract the combircoc data from data from pbmc3k.final (case class: Monocytes)
data <- seurat_to_combiroc(pbmc3k.final, gene_list = gene_list, labelled_data = TRUE,
                           case_class = c('CD14+ Mono','FCGR3A+ Mono'), 
                           case_label = 'Monocyte', control_label='Other')
head(data)