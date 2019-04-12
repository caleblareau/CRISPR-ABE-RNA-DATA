library(dplyr)
library(rtracklayer)
library(BSgenome.Hsapiens.UCSC.hg38)
library(Biostrings)
library(reshape2)
library(stringr)
library(data.table)
library(diffloop)
library(seqinr)

# Import annotation data only if it is missing from the environment
if(!exists("exome_hepg2")){
  source("00_helperdata-abesecure.R")
}

# Import functions to facilitate data preparation
source("01_essentialFunctions-abesecure.R")

do_all_ABE_exp8 <- function(simple_name){
  
  cell_type = "HEK293"
  full_bamreadcount_library_file <- paste0("/data/joung/caleb/base_editing/exp8-novaseq-ds/bam-readcount/", simple_name, ".all_positions.txt.gz")
  
  if(cell_type == "HEK293"){
    dna_variants=exome_hek293t
  }else if(cell_type == "HepG2"){
    dna_variants=exome_hepg2
  }
  
  # Create new variables based on input
  step1_br_filter_file <- paste0("bam-readcount/" , simple_name, "-HQcounts.tsv")
  
  # Step 1 - Determine universe of possible edits / non-edits from bam-readcount data
  call_bam_readcount_ABE(full_bamreadcount_library_file , step1_br_filter_file)
  
  # Step 2 - Determine universe of possible edits / non-edits from bam-readcount data
  new_fastas <- processFastaSample_ABE(simple_name, step1_br_filter_file, dna_variants, gtf_forward, gtf_reverse, pad = 50)
  
  # Step 3 - Annotate secondary structure for all files generated in step 2
  new_structure_files <- secondaryStructureLaunch(unlist(new_fastas), simple_name)
  
  # Step 4 - remove/compress for economy
  system(paste0("rm ", step1_br_filter_file))
  simple_name
}




if(TRUE){
  
  lapply(paste0("243", c("A", "B", "C", "D", "E")), do_all_ABE_exp8)
  lapply(paste0("244", c("A", "B", "C", "D", "E")), do_all_ABE_exp8)
  lapply(paste0("247", c("A", "B", "C", "D", "E", "F")), do_all_ABE_exp8)
 
}

