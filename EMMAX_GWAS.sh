#!/bin/bash
VCF=$1
DIR=$2
PHENOTYPE_FILE=$3
OUTPUT_DIR=$4

DIRECTORY=${DIR%%\/}
DIRVCF=${DIRECTORY}/${VCF##*/}
NAME=${DIRVCF%%.vcf.gz}

/home/mjahani/bin/emmax-intel64 -v -d 10 -t $NAME -p $PHENOTYPE_FILE -k ${NAME}.aIBS.kinf -c ${NAME}.cov -o ${OUTPUT_DIR}${NAME##*/}_$(basename "${PHENOTYPE_FILE%%.txt}")
Rscript manhattan.R ${OUTPUT_DIR}${NAME##*/}_$(basename "${PHENOTYPE_FILE%%.txt}").ps $OUTPUT_DIR
