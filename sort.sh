#!/bin/bash
#SBATCH --job-name="sort"
#SBATCH -t 08:00:00 #this takes  longer so Jessica recommends allowing more time
#SBATCH --mail-type=FAIL --mail-user=kbernabe@uri.edu
#SBATCH --exclusive
##SBATCH --array=1 #testing one folder but still needs to be run as an array
#SBATCH --array=[0-7]%4
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36

#set array task id

CONDITION_NAMES=( "B1-C-UV_S142" "B2-C-NonUV_S143" "B3-C-June_S144" "B3-S4-UV_S140" "B4-S4-NonUV_S141" "B4-C-June_S145" "B5-S4-June_S146" "B8-S4-June_S147" )

#echo ${CONDITION_NAMES}
#echo ${CONDITION_NAMES[5]}
#echo ${CONDITION_NAMES[@]}


module purge 

CONDITION_NAME=${CONDITION_NAMES[$SLURM_ARRAY_TASK_ID]}
echo ${CONDITION_NAME}
echo ${SLURM_ARRAY_TASK_ID}

source /data/marine_diseases_lab/kira/variables.sh #added the path to differentiate it from Jessica's script

#mkdir -p $SORTMERNA_OUTPUT_LOC #defined this in variables.sh

mkdir -p $SORTMERNA_MRNA_OUTPUT_LOC #this is the output needed for the rest of the pipeline

echo "Loading QIIME2"
module load QIIME2/2021.8

#SORTMERNA_DIR_J=/home/jcoppersmith/src/paired_ends_experiment_20220419/one-off-sources/sortmerna/data #it doesn't look like I have permission to write this file

SORTMERNA_DIR_K=/home/kbernabe/sortmerna_data #copied Jessica's file into my directory so I can have permission to write 

#SORTMERNA_DIR=/data/marine_diseases_lab/kira/merged_reads #I hope this is the correct folder (it is not, see SORTMERNA_DIR_K)

#zcat ${MERGED_READ_DIR}${CONDITION_NAME}_merged.fastq.gz > ${UNGZIPPED_MERGED_OUTPUT_LOC}${CONDITION_NAME}_merged.fastq # Decompress the file \
#remember to get rid of .gz in next step after it's unzipped

#don't need fasta extension

echo "Running SortmeRNA"
sortmerna --ref $SORTMERNA_DIR_K/data/rRNA_databases/silva-bac-16s-id90.fasta,$SORTMERNA_DIR_K/data/index/silva-bac-16s-db \
--reads $UNGZIPPED_MERGED_OUTPUT_LOC${CONDITION_NAME}_merged.fastq \
--aligned $SORTMERNA_OUTPUT_LOC${CONDITION_NAME}_sortmerna_aligned.fastq \
--other $SORTMERNA_MRNA_OUTPUT_LOC${CONDITION_NAME}_sortmerna_mrna.fastq \
--fastx \
--num_alignments 1 --blast 0

