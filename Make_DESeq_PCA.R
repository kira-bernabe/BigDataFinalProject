# make_DESeq_PCA.R
# Created 6/28/16
# Last updated 6/16/2017
# Run with --help flag for help.

suppressPackageStartupMessages({
  library(optparse)
})

option_list = list(
  make_option(c("-I", "--input"), type="character", default="./",
              help="Input directory", metavar="character"),
  make_option(c("-O", "--out"), type="character", default="PCA_plot.tab",
              help="output file name [default= %default]", metavar="character")
)

#opt_parser = OptionParser(option_list=option_list);
#opt = parse_args(opt_parser);

#print("USAGE: $ run_DESeq_stats.R -I working_directory/ -O save.filename -L level (1,2,3,4)")


PCA_plot <- function(input, div) {
  
  # check for necessary specs
  if (is.null(input)) {
    print ("WARNING: No working input directory specified with '-I' flag.")
    stop()
  } else {  cat ("Working directory is ", input, "\n")
    wd_location <- input
    setwd(wd_location)  }
  
  #cat ("Saving results as ", opt$out, "\n")
  #save_filename <- opt$out
  
  #cat ("Calculating DESeq results for hierarchy level ", opt$level, "\n")
  
  # import other necessary packages
  suppressPackageStartupMessages({
    library(DESeq2)
    library("pheatmap")
    library(ggplot2)
  })
  
  # GET FILE NAMES
  control_files <- list.files(
    pattern = "controlorg_*", full.names = T, recursive = FALSE)
  control_names = ""
  for (name in control_files) {
    control_names <- c(control_names, unlist(strsplit(name, split='_', fixed=TRUE))[4])}
  control_names <- control_names[-1]
  control_names_trimmed = ""
  for (name in control_names) {
    control_names_trimmed <- c(control_names_trimmed, unlist(strsplit(name, split='.', fixed=TRUE))[1])}
  control_names_trimmed <- control_names_trimmed[-1]
  
  exp_files <- list.files(
    pattern = "experimentalorg_*", full.names = T, recursive = FALSE)
  exp_names = ""
  for (name in exp_files) {
    exp_names <- c(exp_names, unlist(strsplit(name, split='_', fixed=TRUE))[4])}
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
      control_table <- read.table(file = x, header = F, quote = "", sep = "\t")
      colnames(control_table) = c("DELETE", x, "V3")
      control_table <- control_table[,c(2,3)]      }
    if (y > 1) {
      temp_table <- read.table(file = x, header = F, quote = "", sep = "\t")
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
      exp_table <- read.table(file = x, header=F, quote = "", sep = "\t")
      colnames(exp_table) = c("DELETE", x, "V3")
      exp_table <- exp_table[,c(2,3)]  }
    if (y > 1) {
      temp_table <- read.table(file = x, header = F, quote = "", sep = "\t")
      colnames(temp_table) = c("DELETE", x, "V3")
      exp_table <- merge(exp_table, temp_table[,c(2,3)], by = "V3", all = T)  }
  }
  exp_table[is.na(exp_table)] <- 0
  rownames(exp_table) = exp_table$V3
  exp_table_trimmed <- exp_table[,-1]
  
  # getting the column names simplified
  colnames(control_table_trimmed) = control_names_trimmed
  colnames(exp_table_trimmed) = exp_names_trimmed
  
  complete_table <- merge(control_table_trimmed, exp_table_trimmed, by=0, all = TRUE)
  complete_table[is.na(complete_table)] <- 1
  rownames(complete_table) <- complete_table$Row.names
  complete_table <- complete_table[,-1]
  completeCondition <- data.frame(condition=factor(c(
    rep(paste("control", 1:length(control_files), sep=".")),
    rep(paste("experimental", 1:length(exp_files), sep=".")))))
  completeCondition1 <- t(completeCondition)
  colnames(complete_table) <- completeCondition1
  completeCondition2 <- data.frame(condition=factor(c(
    rep("control", length(control_files)),
    rep("experimental", length(exp_files)))))
  
  dds <- DESeqDataSetFromMatrix(complete_table, completeCondition2, ~condition)
  
  dds <- DESeq(dds)
  transformed_data <- rlog(dds, blind=FALSE)
  
  # making the PCA plot
  
  # calculate euclidean distances from the variance-stabilized data
  dists <- dist(t(assay(transformed_data)))
  PCAplot <- plotPCA(transformed_data, intgroup = "condition", returnData = TRUE)
  percentVar <- round(100 * attr(PCAplot, "percentVar"))
  
  # label each descrete point with actual condition (not just control/experimental)
  PCAplot$group <- c("B1-C-UV_S142", "B3-C-June_S144",  "B4-C-June_S145", "B3-S4-UV_S140", "B5-S4-June_S146", "B8-S4-June_S147")
  
  # saving and finishing up
  #cat ("Saving PCA plot as ", save_filename, " now.\n")
  #pdf(file = paste(save_filename,".pdf",sep = ""), width=18, height=10)
  plot <-ggplot(PCAplot, aes(PC1, PC2, color=condition)) +
    geom_point(size=2) +
    geom_text(aes(label=group), hjust=0.1, vjust=-0.1) + # this is commented out in original code
    ggtitle("PCA Plot of control vs. experimental organism data") + #qualify which data it is
    theme(legend.position = "bottom") +
    xlab(paste0("PC1: ",percentVar[1],"% variance")) + ylim(-30,30) +
    ylab(paste0("PC2: ",percentVar[2],"% variance")) + xlim(-30,30) #xlim needs to be adjusted because not all points are falling in the range
  #dev.off()
  
  return(plot)
  
}

pdf(file = "~/Samsa2MetaFinal/organism/pcaplot.pdf", width=5, height=4)
PCA_plot("~/Samsa2MetaFinal/organism") #specify folder
dev.off()

