#' Calculate CPM values for a tibble of counts and return specific genes only
#' @param counts Counts as tibble (gene or transcript ID in a column) 
#' @param gene.col The name of the column that has the gene names or transcript IDs
#' @param goi Genes interested in finding CPM values for 
#' @param log Whether you want logCPM or not. Default is TRUE
#' @return A tibble with CPM for genes of interest
#' @examples
#' cpmGeneExpr(counts, gene.col = "Genes", goi = c("Gene_1","Gene_2"))
#' @export

cpmGeneExpr <- function(counts, gene.col, goi, log = TRUE) { 
  counts <- tibble::column_to_rownames(counts, var = gene.col)
  if(isTRUE(log)){ 
    counts <- edgeR::cpm(counts, log = TRUE) 
  } else { 
        counts <- edgeR::cpm(counts, log = FALSE)
  } 
  counts <- tibble::as_tibble(counts, rownames = gene.col)
  counts <- dplyr::filter(counts, !!as.name(gene.col) %in% c(goi))
  counts <- tidyr::pivot_longer(counts,cols = -all_of(gene.col), names_to = "Samples",
                                values_to = "CPM")
  return(counts)
} 
