#!/bin/bash
#SBATCH --job-name="annotate"
#SBATCH -t 24:00:00 #this takes  longer so Jessica recommends allowing more time
#SBATCH --mail-type=FAIL --mail-user=kbernabe@uri.edu
#SBATCH --exclusive
#SBATCH --array=1 #testing one folder but still needs to be run as an array
##SBATCH --array=[0-7]%4
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36

#set array task id

CONDITION_NAMES=( "B1-C-UV_S142" "B2-C-NonUV_S143" "B3-C-June_S144" "B3-S4-UV_S140" "B4-S4-NonUV_S141" "B4-C-June_S145" "B5-S4-June_S146" "B8-S4-June_S147" )

echo ${CONDITION_NAMES}
echo ${CONDITION_NAMES[5]}
echo ${CONDITION_NAMES[@]}



CONDITION_NAME=${CONDITION_NAMES[$SLURM_ARRAY_TASK_ID]}
echo ${CONDITION_NAME}
echo ${SLURM_ARRAY_TASK_ID}

source /data/marine_diseases_lab/kira/variables.sh #added the path to differentiate it from Jessica's script


module load DIAMOND/2.0.11-GCC-10.3.0 #don't know if this is the right version


SORTMERNA_MRNA_OUTPUT_LOC=${ROOT}sortmerna_mrna_output/ 

#mv $SORTMERNA_MRNA_OUTPUT_LOC${CONDITION_NAME}_sortmerna_mrna.fastq.fastq $SORTMERNA_MRNA_OUTPUT_LOC${CONDITION_NAME}_sortmerna_mrna.fastq

#for diamond command, number of threads is automatic, and specify blastx, db (which is in variables), -q designates input, -o is output

#change file extension to fastq.fastq in next version


diamond blastx -d $DIAMOND_DATABASE_LOC \
-f 100 \
-q ${SORTMERNA_MRNA_OUTPUT_LOC}${CONDITION_NAME}_sortmerna_mrna.fastq.fastq \
-o ${DIAMOND_OUTPUT_LOC}${CONDITION_NAME} \
-k 1
 
