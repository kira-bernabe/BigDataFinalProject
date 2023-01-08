##BIO539 Final Project


This is the final project for BIO539, where we had to use code that we learned throughout class 
to analyze and visualize data. The data I am using is for a project from the Gomez-Chiarri Lab with whom I
collaborate. We are looking at the metatranscriptome of oyster hatcheries before and after they
are treated with the probiont *Phaeobacter inhibens*. It was suggested to me by Jessica Coppersmith, Dr Gomez-Chiarri's 
graduate student whose data this is, to use SAMSA2 for the analysis. 

SAMSA2 is an open source pipeline using python, bash, and R to take raw sequencing reads and generate 
plots to visualize the metatranscriptome of environments. There are many dependencies included in the pipeline; 
PEAR, Trimmomatic, SortMeRNA, and DIAMOND. These dependencies can be dowmloaded when installing SAMSA2 with the 
install_packages.bash script, but I had these installed onto the Andromeda HPC by Kevin Bryan. Because there was
a licensing issue with PEAR, I used bbmerge instead.

*I did not right this code*, but I made adjustments where necessary to get the data analyzed the most efficiently.

All of the original SAMSA2 code can be found in the repository here: https://github.com/transcript/samsa2

Beginning in the command line, all of the bash scripts are run as array jobs, and the script variable.sh
holds all of the outputs generated throughout the pipeline connected to the root dataset. Variables.sh should be included
in all of the bash scripts.

Take the raw paired end sequencing reads and merge them with bbmerge.sh. The output ia a
fastq file with the merged paired ends. This will be used as the input for trimmomatic.sh to clean them.
That fastq output is the input for the ribodepletion with SortMeRNA, using sort.sh. NOTE: it is important to include
a second flag called "other" to capture the mRNA, or else they will be discarded. 

After preprocessing, the sort.sh output will be annotated using DIAMOND. This is where I deviated from the original pipeline. Instead of searching and then converting the data in once script, use diamond.sh to perform the search against
the database, then use counting.sh to convert the data to a BLAST m8 table. In the SAMSA2 documentation the aggregation
script DIAMOND_analysis_counter.py is performed separately, but I rolled it into counting.sh. Aggregaton generates
two outputs: function and organism. The default is for both outputs to be generated in the same aggregation step,
but I separate function and organism at the counting step to make it easier when things move to R, which is why
there's a counting_function.sh and a counting_organism.sh. 

After DIAMOND, move the files to Rstudio to contiuee with data analysis and plots. If necessary, change the file names
so that each file begins with either "control" or "experiment". Run Install_DESeq.R and then run Run_DESeq_stats.R for
analysis. From there, run Diversity_stats.R and Diversity_graphs.R to get the Shannon and Simpson diversity indices and
bar graphs. Run Make_combined_graphs.R for the stacked graphs of most abundant reads, and then run Make_DESeq_PCA.R and 
Make_DESeq_heatmap.R to make the those plots. I modified each R script so that they can be run as functions, and my 
knowledge isn't sophisticated enough so for now the functions have to be run separately depending if the the desired
outcome is functional or organismal data. Most of the orignal code has not beem altered, but I made some modifications.
To distringuish between my comments and those orignally there I put my intials at the end. 
