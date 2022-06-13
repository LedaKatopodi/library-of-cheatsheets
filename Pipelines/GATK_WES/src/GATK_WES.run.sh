#!/bin/bash

## Wrapper script for running the GATK Variant Calling Pipeline (WES) from end-to-end

## Get Arguments
while getopts d:n:1:2:g:s:c:f:r:m: flag
do
	case "${flag}" in
		d) wkDir=${OPTARG};;
		n) sample=${OPTARG};;
		1) r1=${OPTARG};;
		2) r2=${OPTARG};;
		g) germline=${OPTARG};;
		s) somatic=${OPTARG};;
		c) varcalling=${OPTARG};;
		f) varfiltering=${OPTARG};;
		r) gatkresources=${OPTARG};;
		m) ncbi=${OPTARG};;
	esac
done

# -- Run Pipeline -- #

## == Download GATK Resources == #
if [ $gatkresources == true ]
then

	echo -e "Step 0: Downloading GATK Resources\n"

	sh GATK_WES.aux_src.GATK_Resources.sh -d $wkDir \
	-m $ncbi

fi

## == Variant Calling == #
if [ $varcalling == true ]
then

	echo -e "Step 1: Running Variant Calling\n"

	sh GATK_WES.aux_src.VariantCalling.sh -d $wkDir \
	-n $sample \
	-1 $r1 -2 $r2 \
	-g $germline -s $somatic

fi

## == Variant Filtering == #
if [ $varfiltering == true ]
then

	echo -e "Step 2: Running Variant Filtering and Annotation\n"

	sh GATK_WES.aux_src.VariantFiltering.sh -d $wkDir \
	-n $sample \
	-g $germline -s $somatic
	
fi

