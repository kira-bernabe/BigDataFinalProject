BASE_EXPERIMENT_NAME=Metatranscriptomes2021 #This should be descriptive of the overall experiment being run, this data comes from Jessica Coppersmith
#GENOME_NAME=S4Sm # Can change this as makes sens

#ALL_GENOMES="S4Sm JC3" # This should be all the genomes you expect to need

ROOT=/data/marine_diseases_lab/kira/ #made a root to differentiate from Jessica's files, everything from now on should be referenced from this

RAW_DATA_LOC=/data/marine_diseases_lab/kira/fastq_zipped_reads/ # This is the raw data from the sequencing run

TRIM_DATA_LOC=${ROOT}trimmed_reads/ #trimmomatic output

MERGED_READ_DIR=${ROOT}merged_reads/ #bbmerge output

UNGZIPPED_MERGED_OUTPUT_LOC=${ROOT}scratch/ #decompressed output (must be done before sortmerna, use zcat)

SORTMERNA_OUTPUT_LOC=${ROOT}sortmerna_output/ #ribodepletion output

SORTMERNA_MRNA_OUTPUT_LOC=${ROOT}sortmerna_mrna_output/ #ribodepletion mrna output (what we need)

DIAMOND_OUTPUT_LOC=${ROOT}diamond_output/ #annotation output



AGGREGATE_ORGANISM_OUTPUT_LOC=${ROOT}organism_output/ 

AGGREGATE_FUNCTION_OUTPUT_LOC=${ROOT}function_output/





#FASTQ_OUTPUT_LOC=${ROOT}annotated_fastq/ # Where we will store the FASTQ files for everyone to access

#SM_OUTPUT_LOC=${ROOT}S4sm/ # Where we put the output of CANU

#BUSCO_OUTPUT_LOC=${ROOT}busco_output #used to check completeness of the genome


#RACON_OUTPUT_LOC=${ROOT}racon_output #don't know

EXPERIMENT_NAME=${ROOT}exp_name_20220118 # Good practice to put a date here, rather than regenerate each time, since you might run this on different days for the same experiment,$

DIAMOND_DATABASE_LOC=/data/shared/ncbi-nr/nr-diamond-db.dmnd #don't mess with this

SAMSA_REFSEQ_DB_LOC=/data/shared/samsa/RefSeq_bac.fa #don't mess with this either

SAMSA_PY_DIR=/home/jcoppersmith/src/paired_ends_experiment_20220419/samsa2/python_scripts

SAMSA_PYTHON_OUTPUT_LOC=${ROOT}samsa_counter_output



# BELOW THIS LINE THE SCRIPT POPULATES FOR YOU

TODAY=`date "+%Y-%m-%d"`

TEMP_DATA_LOC=~/data/${EXPERIMENT_NAME}_TEMP/ # This is where temporary data should be written
FINAL_DATA_LOC=~/data/${EXPERIMENT_NAME}_RESULTS/ #This is where results data should be written



MERGED_GENOME_LOC=${TEMP_DATA_LOC}${BASE_EXPERIMENT_NAME}_stringtie_merged.gtf # This is where yous hould expect the merged genome to end up
SAMPLE_LIST_FILE_LOC=${TEMP_DATA_LOC}HARDCODE_${BASE_EXPERIMENT_NAME}_sample_list.txt # This is where you expect the sample lit to be


