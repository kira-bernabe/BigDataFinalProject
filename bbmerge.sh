#!/bin/bash
#SBATCH --job-name="merge"
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

IN1=/data/marine_diseases_lab/kira/trimmed_reads/${CONDITION_NAME}_R1_001_trimmed.fq.gz
IN2=/data/marine_diseases_lab/kira/trimmed_reads/${CONDITION_NAME}_R2_001_trimmed.fq.gz
OUT=/data/marine_diseases_lab/kira/${CONDITION_NAME}_merged.fastq.gz

echo $CONDITION_NAME

module load BBMap/38.96-foss-2020b 

bbmerge.sh in1=$IN1 in2=$IN2 out=$OUT
