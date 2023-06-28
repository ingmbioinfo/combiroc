\dontrun{
demo_seurat# A subset of PBMC3K dataset from Satijia et al. 2015

# list of markers of interest
gene_list<-c('RBP7','CYP1B1','CD14','FCN1','NKG7', 'GNLY')

# to extract the combircoc data from data from pbmc3k.final (case class: Monocytes)
data <- seurat_to_combiroc(demo_seurat, gene_list = gene_list, labelled_data = TRUE,
                           case_class = c('CD14+ Mono','FCGR3A+ Mono'),
                           case_label = 'Monocyte', control_label='Other')
head(data)
}
