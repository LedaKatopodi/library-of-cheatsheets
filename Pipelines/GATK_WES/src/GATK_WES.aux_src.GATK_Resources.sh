#!/bin/bash

CORES=${SLURM_CPUS_PER_TASK}

# -- Arguments -- #

while getopts d:m: flag
do
	case "${flag}" in
		d) wkDir=${OPTARG};;
		m) ncbi=${OPTARG};;
	esac
done

cd $wkDir
mkdir GATKResources

# -- GATK Resource Bundle Downloads -- #

cd GATKResources

wget https://storage.googleapis.com/gatk-best-practices/somatic-hg38/af-only-gnomad.hg38.vcf.gz
wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz
wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
wget https://storage.googleapis.com/gatk-best-practices/somatic-hg38/small_exac_common_3.hg38.vcf.gz

wget https://storage.googleapis.com/gatk-best-practices/somatic-hg38/af-only-gnomad.hg38.vcf.gz.tbi
wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz.tbi
wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi
wget https://storage.googleapis.com/gatk-best-practices/somatic-hg38/small_exac_common_3.hg38.vcf.gz.tbi

if [ $ncbi == true ]
then

# AF gnomAD VCF
gunzip af-only-gnomad.hg38.vcf.gz
sed 's/chr//g' af-only-gnomad.hg38.vcf > af-only-gnomad.hg38.NCBI.vcf
bgzip -i af-only-gnomad.hg38.NCBI.vcf
tabix af-only-gnomad.hg38.NCBI.vcf.gz

# HapMap VCF
gunzip hapmap_3.3.hg38.vcf.gz
sed 's/chr//g' hapmap_3.3.hg38.vcf > hapmap_3.3.hg38.NCBI.vcf
bgzip -i hapmap_3.3.hg38.vcf
tabix hapmap_3.3.hg38.vcf.gz

# Mills VCF
gunzip Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
sed 's/chr//g' Mills_and_1000G_gold_standard.indels.hg38.vcf > Mills_and_1000G_gold_standard.indels.hg38.NCBI.vcf
bgzip -i Mills_and_1000G_gold_standard.indels.hg38.NCBI.vcf
tabix Mills_and_1000G_gold_standard.indels.hg38.NCBI.vcf.gz

# Biallelic AF Gnomad
gunzip small_exac_common_3.hg38.vcf.gz
sed 's/chr//g' small_exac_common_3.hg38.vcf > small_exac_common_3.hg38.NCBI.vcf
grep grep -vE "(v1|_random)" small_exac_common_3.hg38.NCBI.vcf > small_exac_common_3.hg38.NCBI.norv1.vcf
bgzip -i small_exac_common_3.hg38.NCBI.norv1.vcf
tabix small_exac_common_3.hg38.NCBI.norv1.vcf.gz

fi
