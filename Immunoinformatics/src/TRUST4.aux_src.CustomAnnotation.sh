# Auxiliary Code for Generating TRUST4 Custom Annotation

## Get Arguments
while getopts o:g:f:l: flag
do
	case "${flag}" in
		o) organism=${OPTARG};;
		g) gtf=${OPTARG};;
		f) fasta=${OPTARG};;
		l) vdjclist=${OPTARG};;
	esac
done

annDir=~/TRUST4/custom_${organism}
mkdir $annDir

## Download reference from IMGT
perl ~/TRUST4/BuildImgtAnnot.pl $organism > $annDir/IMGT+C.fa

## Get the BCR/TCR Gene names from the Reference file
grep ">" $annDir/IMGT+C.fa | cut -f2 -d'>' | cut -f1 -d'*' | sort | uniq > $annDir/vdjc.list
vdjclist=$annDir/vdjc.list

## Build custom V, J, C gene database
perl ~/TRUST4/BuildDatabaseFa.pl $fasta $gtf $vdjclist > $annDir/bcrtcr.fa
