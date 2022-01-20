#!/bin/bash

VCF=$1
SAMPLES=$2
DIR=$3

DIRECTORY=${DIR%%\/}
DIRVCF=${DIRECTORY}/${VCF##*/}
NAME=${DIRVCF%%.vcf.gz}

# Convert to PLINK format
/home/mjahani/bin/plink --vcf $VCF --keep $SAMPLES --set-missing-var-ids @:# --maf 0.03 --allow-extra-chr --recode12 --output-missing-genotype 0 --transpose --out $NAME

#Edit the ID colimn in tped and map files
sed -i 's/^Ha412HOChr//g' ${NAME}.tped
sed -i 's/^Ha412HOChr//g' ${NAME}.map

#LD Pruning with PLINK
/home/mjahani/bin/plink --tfile $NAME --allow-extra-chr --indep-pairphase 50kb 50 0.2 --out $NAME

find $DIRECTORY -type f -regextype "posix-egrep" -iregex ".*${NAME##*/}\.(log|nosex|prune.out)" -delete

#PCA calculation with PLINK
/home/mjahani/bin/plink --tfile $NAME --allow-extra-chr --extract ${NAME}.prune.in --pca 3 --out $NAME
find $DIRECTORY -type f -regextype "posix-egrep" -iregex ".*${NAME##*/}\.(log|nosex|prune.in|eigenval)" -delete
awk '{print $1,"\t",$2,"\t",1,"\t",$3,"\t",$4,"\t",$5}' ${NAME}.eigenvec >${NAME}.cov
rm ${NAME}.eigenvec

#kinship calculation with EMMAX
/home/mjahani/bin/emmax-kin-intel64 -v -s -d 10 ${NAME}
