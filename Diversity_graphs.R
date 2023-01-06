# diversity_graphs.R
# Created 8/11/16
# Last updated 6/16/2017
# Run with --help flag for help.

#suppressPackageStartupMessages({
  #library(optparse)
#})

#option_list = list(
 # make_option(c("-I", "--input"), type="character", default="./",
             # help="Input directory", metavar="character"),
  #make_option(c("-O", "--out"), type="character", default="diversity_graph.pdf", 
             # help="output file name [default= %default]", metavar="character")
#)

#opt_parser = OptionParser(option_list=option_list);
#opt = parse_args(opt_parser);

#print("USAGE: $ diversity_graphs.R -I working_directory/ -O save.filename")

diversity_graphs <-function(input, div) { 
  
  # check for necessary specs
  if (is.null(input)) {
    print ("WARNING: No working input directory specified with '-I' flag.")
    stop()
  } else {  cat ("Working directory is ", input, "\n")
    wd_location <- input  
    setwd(wd_location)  }
  
  #cat ("Saving diversity graphs as", opt$out, "\n")
  #save_filename <- opt$out
  
  # import other necessary packages
  suppressPackageStartupMessages({
    library(scales)
    library(reshape2)
    library(knitr)
    library(vegan)
    library(gridExtra)
    library(ggplot2)
  })
  
  # GET FILE NAMES
  control_files <- list.files(
    pattern = "controlorg_*", full.names = T, recursive = FALSE) #specify output to #readin
  control_names = ""
  for (name in control_files) {
    control_names <- c(control_names, unlist(strsplit(name, split='_', fixed=TRUE))[2])}
  control_names <- control_names[-1]
  control_names_trimmed = ""
  for (name in control_names) {
    control_names_trimmed <- c(control_names_trimmed, unlist(strsplit(name, split='.', fixed=TRUE))[1])}
  control_names_trimmed <- control_names_trimmed[-1]
  
  exp_files <- list.files(
    pattern = "experimentalorg_*", full.names = T, recursive = FALSE)
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
      control_table <- read.table(file = x, header = F, quote = "", sep = "\t", fill = TRUE)
      colnames(control_table) = c("DELETE", x, "V3")
      control_table <- control_table[,c(2,3)]      }
    if (y > 1) {
      temp_table <- read.table(file = x, header = F, quote = "", sep = "\t", fill = TRUE)
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
      exp_table <- read.table(file = x, header=F, quote = "", sep = "\t", fill = TRUE)
      colnames(exp_table) = c("DELETE", x, "V3")
      exp_table <- exp_table[,c(2,3)]  }
    if (y > 1) {
      temp_table <- read.table(file = x, header = F, quote = "", sep = "\t", fill = TRUE)
      colnames(temp_table) = c("DELETE", x, "V3")
      exp_table <- merge(exp_table, temp_table[,c(2,3)], by = "V3", all = T)  }
  }
  exp_table[is.na(exp_table)] <- 0
  rownames(exp_table) = exp_table$V3
  exp_table_trimmed <- exp_table[,-1]
  
  # getting the column names simplified
  #colnames(control_table_trimmed) = control_names_trimmed
  #colnames(exp_table_trimmed) = exp_names_trimmed
  
  # merging the two tables together
  complete_table <- merge(control_table_trimmed, exp_table_trimmed, by=0, all = TRUE)
  complete_table[is.na(complete_table)] <- 0
  rownames(complete_table) <- complete_table$Row.names
  complete_table <- complete_table[,-1]
  
  # getting diversity statistics
  flipped_complete_table <- data.frame(t(complete_table))
  
  
  graphing_table <- data.frame(condition=factor(c(rep("control", length(control_files)), 
                                                  rep("experimental", length(exp_files)))))
  graphing_table[,"order"] <- c(1:nrow(graphing_table))
  graphing_table[,"Shannon"] <- diversity(flipped_complete_table, index = "shannon")
  graphing_table[,"Simpson"] <- diversity(flipped_complete_table, index = "simpson")
  
  #add individual lables on x axis (call them samples or else it will say labels)
  graphing_table$samples <- c("B1-C-UV_S142", "B3-C-June_S144",  "B4-C-June_S145", "B3-S4-UV_S140", "B5-S4-June_S146", "B8-S4-June_S147")
  
  
  if (div == "Shannon") {
    plot <- ggplot(data = graphing_table, aes(x=samples, y=Shannon, #change x=order to x=labels
                                              color = condition, fill = condition)) + 
      geom_bar(stat="identity", width = 0.8) +
      ggtitle("Shannon diversity of control vs experimental organism samples") + #qualify which data this is
      theme(legend.position = "bottom", text = element_text(face = "bold")) + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust= 0.5)) #adjust the angle of labels
  }
  if (div == "Simpson") {
    plot <- ggplot(data = graphing_table, aes(x=samples, y=Simpson, 
                                              color = condition, fill = condition)) + 
      geom_bar(stat="identity", width = 0.8) +
      ggtitle("Simpson diversity of control vs experimental organism samples") + #qualify which data this is
      theme(legend.position = "bottom", text = element_text(face = "bold")) + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust= 0.5))
  }
  #cat ("\nSuccess!\nSaving diversity graphs as ", save_filename, " now.\n")
  #pdf(file = save_filename, width=10, height=7)
  #grid.arrange(shannon_plot, simpson_plot, ncol=1)
  #dev.off()
  
  return(plot)
  
}

shannon_plot <- diversity_graphs("~/Samsa2MetaFinal/organism", "Shannon")
shannon_plot

simpson_plot <- diversity_graphs("~/Samsa2MetaFinal/organism", "Simpson")
simpson_plot



pdf(file = "diversity_graphs.pdf", width=10, height=7)
grid.arrange(shannon_plot, simpson_plot, ncol=1)
dev.off()

