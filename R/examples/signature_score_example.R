cbmc # combiroc built-in Seurat object for cbmc dataset 

nk_genes # NK specific gene signature found with Seurat protocol

# To compute the gene signature score of a signature according to DellaChiara et al.
NK_sig_cbmc <- signature_score(SeuratObj = cbmc, geneset = nk_genes)