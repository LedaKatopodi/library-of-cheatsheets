# Code for running ggsashimi

## Important!
export GGSASHIMI_DEBUG=yes 

## Get Arguments
while getopts d:g:c:o: flag
do
	case "${flag}" in
		d) wkDir=${OPTARG};;
		g) gtf=${OPTARG};;
		c) coord=${OPTARG};;
		o) outprefix=${OPTARG};;
	esac
done

if [ -z "$coord" ]; then echo "Error: -c argument required."; exit; fi
if [ -z "$outprefix" ]; then 
	coord2=$(sed 's/:/-/g' <<< "$coord")
	outprefix=$(echo $coord2"_Sashimi")
	echo "Setting output prefix to: " $outprefix
fi

## Create Output Directory
mkdir $wkDir/SashimiPlots
cd $wkDir/SashimiPlots

## Create palette, assuming 2 Groups
echo -e "#3399FF\n#FF661A" > palette.tsv
## Running ggsashimi
~/ggsashimi.py -b $wkDir/ggsashimi_inputBams.tsv -c $coord  \
-g $gtf --out-prefix $outprefix \
-M 10 -C 3 -O 3 --alpha 0.25 --base-size 20 --ann-height 1.5 --height 3 --width 10 --shrink \
--palette palette.tsv --fix-y-scale --out-format png
## Generatinf Plot
Rscript R_script
