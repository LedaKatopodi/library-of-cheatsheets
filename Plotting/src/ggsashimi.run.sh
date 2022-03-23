# Code for running ggsashimi

## Important!
export GGSASHIMI_DEBUG=yes 

## Get Arguments
while getopts d:g: flag
do
	case "${flag}" in
		d) wkDir=${OPTARG};;
		g) gtf=${OPTARG};;
	esac
done

## Create Output Directory
mkdir $wkDir/SashimiPlots
cd $wkDir/SashimiPlots

## Create palette, assuming 2 Groups
echo -e "#3399FF\n#FF661A" > palette.tsv
## Running ggsashimi
~/ggsashimi.py -b $wkDir/ggsashimi_inputBams.tsv -c 12:6693791-6700815  \
-g $gtf --out-prefix "PIANP_12-6693791-6700815_Sashimi" \
-M 10 -C 3 -O 3 --alpha 0.25 --base-size 20 --ann-height 1.5 --height 3 --width 10 --shrink \
--palette palette.tsv --fix-y-scale --out-format png
## Generating Plot
Rscript R_script
