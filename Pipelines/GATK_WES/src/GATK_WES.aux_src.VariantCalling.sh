#!/bin/bash

## Auxiliary Script for running the GATK Variant Calling Pipeline (WES)

CORES=$(nproc)

## Get Arguments
while getopts d:n:1:2:g:s: flag
do
	case "${flag}" in
		d) wkDir=${OPTARG};;
		n) sample=${OPTARG};;
		1) r1=${OPTARG};;
		2) r2=${OPTARG};;
		g) germline=${OPTARG};;
		s) somatic=${OPTARG};;
	esac
done

cd $wkDir

# -- Auxiliary Files -- #

gnomad=$wkDir"/aux/af-only-gnomad.hg38.NCBI.vcf"
ref=$wkDir"/aux/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

# -- Mapping -- #

bwaDir=${sample}".BWA"
mkdir ${bwaDir}
bwa mem -M -t $CORES -R '@RG\tID:'${sample}'\tLB:'${sample}'\tPL:ILLUMINA\tPM:HISEQ\tSM:'${sample} \
$ref ${r1} ${r2} > ${bwaDir}/${sample}.sam
samtools view -Sb -@ $CORES ${bwaDir}/${sample}.sam > ${bwaDir}/${sample}.bam

# -- Pre-processing -- #

varcallDir=${sample}".VariantCalling"
mkdir $varcallDir

file=${bwaDir}/${sample}.bam
samtools sort -n -@ $CORES -m 2G -o ${bwaDir}/${sample}".sort.bam" ${file}
samtools fixmate -@ $CORES -m ${bwaDir}/${sample}".sort.bam" ${bwaDir}/${sample}".sort.fixmate.bam"
samtools sort -@ $CORES -o ${bwaDir}/${sample}".pos_sort.bam" ${bwaDir}/${sample}".sort.fixmate.bam"
samtools index -@ $CORES -b ${bwaDir}/${sample}".pos_sort.bam" ${bwaDir}/${sample}".pos_sort.bam.bai"
file=${bwaDir}/${sample}".pos_sort.bam"

## == Mark Duplicates == ##
echo -e "Mark duplicates\n"

gatk MarkDuplicates -I ${file} \
-O ${varcallDir}/${sample}"_dupMarked.bam" \
-M ${varcallDir}/${sample}"_dup.metrics" \
--READ_NAME_REGEX null \
--CREATE_INDEX true \
--VALIDATION_STRINGENCY SILENT \
2>${varcallDir}/${sample}".MarkDuplicates.log"

## == Base Recalibration == ##
echo -e "Base Quality Scores Recalibration\n"

gatk BaseRecalibrator \
-I ${varcallDir}/${sample}"_dupMarked.bam" \
-R $ref \
--known-sites $gnomad \
-O ${varcallDir}/${sample}".recal_data.table" \
2>${varcallDir}/${sample}".BaseRecalibrator.log"

gatk ApplyBQSR \
-R $ref \
-I ${varcallDir}/${sample}"_dupMarked.bam" \
--bqsr-recal-file ${varcallDir}/${sample}".recal_data.table" \
-O ${varcallDir}/${sample}".recal.bam"


# -- Germline Mutations -- #

if [ $germline == true ]
then
	echo -e "Running Haplotype Caller\n"

	# index input bam file
	samtools index -@ $CORES -b ${varcallDir}/${sample}".recal.bam"

	germDir=${varcallDir}/${sample}".Germline"
	mkdir $germDir

	gatk HaplotypeCaller -R $ref \
	-I ${varcallDir}/${sample}".recal.bam" \
	-O ${germDir}/${sample}".vcf.gz" \
	-bamout ${germDir}/${sample}".g.bam" \
	--dont-use-soft-clipped-bases \
	2>${germDir}/${sample}".HapCaller.log"

fi

# -- Somatic Mutations -- #

if [ $somatic == true ]
then
	echo -e "Running Mutect2\n"

	somaDir=${varcallDir}/${sample}".Somatic"
	mkdir $somaDir

	gatk Mutect2 -R $ref \
	-I ${varcallDir}/${sample}".recal.bam" \
	--germline-resource $gnomad \
	--dont-use-soft-clipped-bases \
	-tumor $sample \
	-bamout ${somaDir}/${sample}".mutect2.bam" \
	-O ${somaDir}/${sample}".vcf" \
	2>${somaDir}/${sample}".Mutect2.log"

	### --recover-all-dangling-branches \
	### --min-pruning 0 \
	
fi

