#!/bin/bash
#SBATCH --job-name="count"
#SBATCH -t 08:00:00 
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

module load Python/2.7.18-GCCcore-10.2.0
module load DIAMOND/2.0.11-GCC-10.2.0

diamond view -a ${DIAMOND_OUTPUT_LOC}${CONDITION_NAME}.daa \
-o ${AGGREGATE_FUNCTION_OUTPUT_LOC=${ROOT}function_output}${CONDITION_NAME}.tsv -f 6

python DIAMOND_analysis_counter.py -I ${AGGREGATE_FUNCTION_OUTPUT_LOC=${ROOT}function_output}${CONDITION_NAME}.tsv \
-D ${SAMSA_REFSEQ_DB_LOC} -F

#python DIAMOND_analysis_counter.py -I ${DIAMOND_OUTPUT_LOC}${CONDITION_NAME}.tsv \
#-D ${SAMSA_REFSEQ_DB_LOC} -O



