# GWAS

GWAS with EMMAX algorithm

data preperation

> bash EMMAX_PREP.sh VCF SAMPLES DIR



> VCF = VCF.gz
> 
> SAMPLE = list of samples to kep in VCF
> 
> DIR = Directory to save  files for GWAS


GWAS and Manhattan plot

> bash EMMAX_GWAS.sh VCF DIR PHENOTYPE_FILE OUTPUT_DIR



> VCF = VCF.gz
> 
> DIR = Directory of input data for EMMAX
> 
> PHENOTYPE_FILE = phenotype file with proper format for EMMAX
> 
> OUTPUT_DIR = directory to save GWAS result and manhattan plot
