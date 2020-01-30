### Script that retrieves SNP data from the NCBI database. Simple txt file is 
### required as an input
### Niklas Krupka
### 2020

################################################################################

library(tidyverse)
library(rentrez)

get_ncbi_acc_from_snp <- function(snp = NULL){
  # This function only returns the first found fit for each SNP
  ncbi_acc <- map_chr(snp, ~entrez_search (term = .x,   db = "snp")$ids[1])
  names(ncbi_acc) <- snp
  return(ncbi_acc)
}

get_dbentry_from_ncbi_acc <- function(ncbi_acc = NULL){
  res <- entrez_summary(id = ncbi_acc, db = "snp")
  names(res) <- names(ncbi_acc)
  return(res)
}

get_gene_from_dbentry <- function(dbentry = NULL){
  res <- map_chr(dbentry, 
                 ~ if_else(is_empty(.x$genes), 
                           "",
                           .x$genes$name[1]))
}

################################################################################

snp_file_location <- "../../Unofficial_data_export/20200130_List_of_SNPs.txt"

snp_list <- read_lines(snp_file_location)

ncbi_acc <-  get_ncbi_acc_from_snp(snp_list)
dbentries <- get_dbentry_from_ncbi_acc(ncbi_acc)
gene_names <- get_gene_from_dbentry(dbentries)
