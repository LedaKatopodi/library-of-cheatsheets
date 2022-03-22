# Code for running TRUST4

## Get Arguments
while getopts d:s:c:o:g:f:b: flag
do
	case "${flag}" in
		d) wkDir=${OPTARG};;
		s) sample=${OPTARG};;
		c) custom=${OPTARG};;
		o) organism=${OPTARG};;
		g) gtf=${OPTARG};;
		f) fasta=${OPTARG};;
		b) bam=${OPTARG};;
	esac
done

## Set Variables depending on the Organism
if [ $custom == true ]; then

	annDir=~/TRUST4/custom_${organism}
	ffile=$annDir/bcrtcr.fa
	reffile=$annDir/IMGT+C.fa

else

	if [ $organism == "Homo_sapiens" ]; then

		ffile=~/TRUST4/hg38_bcrtcr.fa
		reffile=~/TRUST4/human_IMGT+C.fa

	elif [ $organism == "Mus_musculus" ]; then

		ffile=~/TRUST4/mouse/GRCm38_bcrtcr.fa
		reffile=~/TRUST4/mouse_IMGT+C.fa

	else

		echo -e "Annotation not provided by TRUST4 developers for $organism. \nGenerating custom annotation for $organism, with \ngtf = $gtf and \nfasta = $fasta \n"
		if [ -z "$gtf" ]; then
			echo "GTF not provided. Exiting."; exit
		fi
		if [ -z "$fasta" ]; then
			echo "FASTA not provided. Exiting."; exit
		fi
		custom=true
	fi
fi


## Build Custom Annotation
if [ $custom == true ]; then

	if [ -f "$ffile" ] && [ -f "$reffile" ]; then
	    echo "Custom Annotation already built. Proceeding..."
	else 
	    echo "Building Custom Annotation..."
	    sh TRUST4.aux_src.CustomAnnotation.sh -o $organism -g $gtf -f $fasta
	fi
	
fi


## Run TRUST4
cores=${nproc}
mkdir $wkDir/TRUST4

echo $ffile
echo $reffile

~/TRUST4/run-trust4 -b "$bam" -f "$ffile" --ref "$reffile" \
-o ${sample}.TRUST4. --od $wkDir/TRUST4 -t $cores

