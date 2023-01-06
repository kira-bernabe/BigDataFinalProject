#!/bin/bash
#SBATCH --job-name="trim"
#SBATCH -t 04:00:00
#SBATCH --mail-type=FAIL --mail-user=kbernabe@uri.edu
#SBATCH --exclusive
#SBATCH --array=[0-7]%4
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

#set IN1 and IN2 here

IN1=/data/marine_diseases_lab/kira/fastq_zipped_reads/${CONDITION_NAME}_R1_001_fastq.gz
IN2=/data/marine_diseases_lab/kira/fastq_zipped_reads/${CONDITION_NAME}_R2_001_fastq.gz 
OUT1P=/data/marine_diseases_lab/kira${CONDITION_NAME}_R1_001_trimmed.fq.gz
OUT1U=/data/marine_diseases_lab/kira${CONDITION_NAME}_R1_001_un.trimmed.fq.gz
OUT2P=/data/marine_diseases_lab/kira${CONDITION_NAME}_R2_001_trimmed.fq.gz
OUT2U=/data/marine_diseases_lab/kira${CONDITION_NAME}_R2_001_un.trimmed.fq.gz

#load module
module load Trimmomatic/0.39-Java-11

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 36 $IN1 $IN2 $OUT1P $OUT1U $OUT2P $OUT2U SLIDINGWINDOW:4:20 MINLEN:36










	

