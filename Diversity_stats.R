# diversity_stats.R
# Created 8/11/16
# Last updated 6/16/2017
# Run with --help flag for help.

#assign the script as a function to run on either organism files or function files KB


diversity_stats <- function(input) {
  
  # check for necessary specs
  if (is.null(input)) {
    print ("WARNING: No working input directory specified with '-I' flag.")
    stop()
  } else {  cat ("Working directory is ", input, "\n")
    wd_location <- input
    setwd(wd_location)  }
  
  # import other necessary packages
  suppressPackageStartupMessages({
    library(scales)
    library(reshape2)
    library(knitr)
    library(vegan)
  })
  
  # GET FILE NAMES
  control_files <- list.files(
    pattern = "control_*", full.names = T, recursive = FALSE)
  control_names = ""
  for (name in control_files) {
    control_names <- c(control_names, unlist(strsplit(name, split='_', fixed=TRUE))[2])}
  control_names <- control_names[-1]
  control_names_trimmed = ""
  for (name in control_names) {
    control_names_trimmed <- c(control_names_trimmed, unlist(strsplit(name, split='.', fixed=TRUE))[1])}
  control_names_trimmed <- control_names_trimmed[-1]
  
  exp_files <- list.files(
    pattern = "experimental_*", full.names = T, recursive = FALSE)
  exp_names = ""
  for (name in exp_files) {
    exp_names <- c(exp_names, unlist(strsplit(name, split='_', fixed=TRUE))[2])}
  exp_names <- exp_names[-1]
  exp_names_trimmed = ""
  for (name in exp_names) {
    exp_names_trimmed <- c(exp_names_trimmed, unlist(strsplit(name, split='.', fixed=TRUE))[1])}
  exp_names_trimmed <- exp_names_trimmed[-1]
  
  # READ IN FILES
  # loading the control table
  y <- 0
  for (x in control_files) {
    y <- y + 1
    if (y == 1) {
      control_table <- read.table(file = x, header = F, quote = "", sep = "\t", fill = T )
      colnames(control_table) = c("DELETE", x, "V3")
      control_table <- control_table[,c(2,3)]      }
    if (y > 1) {
      temp_table <- read.table(file = x, header = F, quote = "", sep = "\t", fill = T )
      colnames(temp_table) = c("DELETE", x, "V3")
      temp_table <- temp_table[,c(2,3)]
      control_table <- merge(control_table, temp_table, by = "V3", all = T)  }
  }
  control_table[is.na(control_table)] <- 0
  rownames(control_table) = control_table$V3
  control_table_trimmed <- control_table[,-1]
  
  # loading the experimental table
  y <- 0
  for (x in exp_files) {
    y <- y + 1
    if (y == 1) {
      exp_table <- read.table(file = x, header=F, quote = "", sep = "\t", fill = T )
      colnames(exp_table) = c("DELETE", x, "V3")
      exp_table <- exp_table[,c(2,3)]  }
    if (y > 1) {
      temp_table <- read.table(file = x, header = F, quote = "", sep = "\t", fill = T )
      colnames(temp_table) = c("DELETE", x, "V3")
      exp_table <- merge(exp_table, temp_table[,c(2,3)], by = "V3", all = T)  }
  }
  exp_table[is.na(exp_table)] <- 0
  rownames(exp_table) = exp_table$V3
  exp_table_trimmed <- exp_table[,-1]
  
  # merging the two tables together
  complete_table <- merge(control_table_trimmed, exp_table_trimmed, by=0, all = TRUE)
  complete_table[is.na(complete_table)] <- 0
  rownames(complete_table) <- complete_table$Row.names
  complete_table <- complete_table[,-1]
  
  # getting diversity statistics
  flipped_complete_table <- data.frame(t(complete_table))
  
  divShannon_exp <- mean(diversity(flipped_complete_table[grep("exp",rownames(flipped_complete_table)),], index = "shannon"))
  divShannon_con <- mean(diversity(flipped_complete_table[grep("con",rownames(flipped_complete_table)),], index = "shannon"))
  
  divSimpson_exp <- mean(diversity(flipped_complete_table[grep("exp",rownames(flipped_complete_table)),], index = "simpson"))
  divSimpson_con <- mean(diversity(flipped_complete_table[grep("con",rownames(flipped_complete_table)),], index = "simpson"))
  
  #cat ("Shannon diversity index:\n\t", divShannon_exp, " for experimental samples.\n\t",
  #     divShannon_con, " for control samples.\n")
  #cat ("Simpson diversity index:\n\t", divSimpson_exp, " for experimental samples.\n\t",
  #     divSimpson_con, " for control samples.\n")
  return(c(divShannon_exp, divShannon_con, divSimpson_exp, divSimpson_con))
}

list = diversity_stats("~/Samsa2MetaFinal/function/") # just change to appropriate folder KB
exp_shannon = list[1]
con_shannon = list[2]
exp_simpson = list[3]
con_simpson = list[4]
exp_shannon

