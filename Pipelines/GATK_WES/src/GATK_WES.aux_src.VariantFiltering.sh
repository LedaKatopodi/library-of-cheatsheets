#!/bin/bash

## Auxiliary Script for downstream variant filtering (WES)

CORES=$(nproc)

## Get Arguments
while getopts d:n:g:s: flag
do
	case "${flag}" in
		d) wkDir=${OPTARG};;
		n) sample=${OPTARG};;
		g) germline=${OPTARG};;
		s) somatic=${OPTARG};;
	esac
done

cd $wkDir

bwaDir=${sample}".BWA"
varcallDir=${sample}".VariantCalling"
### vepcachedir= ~/VEP/

# -- Tools & Auxiliary Files -- #

gnomad=$wkDir"/GATKResources/af-only-gnomad.hg38.NCBI.vcf.gz"
ref=$wkDir"/aux/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
hapmap=$wkDir"/GATKResources/hapmap_3.3.hg38.NCBI.vcf.gz"
mills=$wkDir"/GATKResources/Mills_and_1000G_gold_standard.indels.hg38.NCBI.vcf.gz"
gnomadbial=$wkDir"/GATKResources/small_exac_common_3.hg38.NCBI.norv1.vcf.gz"

# -- Filtering -- #

if [ $germline == true ]
then

	source activate gatk

	germDir=${varcallDir}/${sample}".Germline"

	$gatk CNNScoreVariants \
	-V ${germDir}/${sample}".vcf.gz" \
	-R $ref \
	-O ${germDir}/${sample}".annotated.vcf"

	$gatk FilterVariantTranches \
	-V ${germDir}/${sample}".annotated.vcf" \
	--resource $hapmap \
	--resource $mills \
	--info-key CNN_1D \
	--snp-tranche 99.95 \
	--indel-tranche 99.4 \
	-O ${germDir}/${sample}".filtered.vcf"

	annDir=$germDir

	conda deactivate


elif [ $somatic == true ]
then
	somaDir=${varcallDir}/${sample}".Somatic"

	$gatk GetPileupSummaries \
	-I ${bwaDir}/${sample}".pos_sort.bam" \
	-V $gnomadbial \
	-L $gnomadbial \
	-O ${somaDir}/${sample}".pileups.table"

	$gatk CalculateContamination \
	-I ${somaDir}/${sample}".pileups.table" \
	-O ${somaDir}/${sample}".contamination.table"
	### --tumor-segmentation ${somaDir}/${sample}".segments.tsv" \

	$gatk FilterMutectCalls \
	-R $ref \
	-V ${somaDir}/${sample}".vcf" \
	--contamination-table ${somaDir}/${sample}".contamination.table" \
	--threshold-strategy OPTIMAL_F_SCORE \
	-O ${somaDir}/${sample}".filtered.vcf"
	### --f-score-beta 10 \
	### --tumor-segmentation ${somaDir}/${sample}".segments.tsv" \

	annDir=$somaDir
fi

$gatk SelectVariants \
-R $ref \
-V ${annDir}/${sample}".filtered.vcf" \
-O ${annDir}/${sample}".filtered_out.vcf" \
--exclude-filtered

# -- Annotation -- #

vep -i ${annDir}/${sample}".filtered_out.vcf" --fork $CORES \
--species homo_sapiens \
--af_gnomad --sift b --polyphen b --gene_phenotype --show_ref_allele \
--numbers --hgvs --symbol --biotype --check_existing --pick_allele \
--plugin SpliceRegion --plugin TSSDistance  \
--force_overwrite --verbose \
--tab --output_file ${annDir}/${sample}".annotatedVEP.tsv"
### --cache --cache_version 98 --dir_cache $vepcachedir --offline
### --canonical --ccds --coding_only 

