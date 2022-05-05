# Tool Cheatsheets

A tool-centric approach on cheatsheets, i.e. *How to Run a Specific Tool 101*.

## Plotting Tools

<details>
<summary>🍣 ggsashimi</summary>

### 🍣 ggsashimi

[ggsashimi](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1006360) is a plotting tool developped by the Guigo lab for the visualization of alternative splicing events. The installation procedure is well documented on their [GitHub page](https://github.com/guigolab/ggsashimi), along with the dependencies. For this cheatsheet the following modules were imported:

* Python/3.6
* R/4.0.1
	* ggplot2/3.3.5
	* data.table/1.14.2
	* gridExtra/2.3

The ggsashimi cheatsheet comes with a single wrapper script, [ggsashimi.run.sh](./src/ggsashimi.run.sh).

### 👟 Running the Cheatsheet

The ggsashimi cheatsheet was built under the following constraints/assumptions:

* The ggsashimi source code is located in the home folder, under `~/ggsashimi.py`. The user can adjust accordingly (line 22).
* For the purposes of this cheatsheet demonstration, the wrapper script contains example code for plotting the splicing events on the PIANP gene (hg38). The coordinates for the example gene are specified by the `-c` argument when running ggsashimi; the output name is specified by the `--out-prefix` argument. The user can adjust accordingly (lines 22 and 23, respectively).
* For the purposes of this cheatsheet demonstration, the wrapper script assumes 2 groups, thus generates a palette of 2 colors. The user can adjust accordingly (line 20). (Note to self: although automatic generation of the color palette goes beyond the scope of this cheatsheet, it would be a nice automation.)

That being said, the example provided in this cheatsheet can be run as:

```
sh ggsashimi.run.sh -d /working/directory
	    	    -g /path/to/gtf/annotation/gtf.gtf
```

See [below](#-arguments--input-files) for more information regarding the arguments.

⚠️ It should also be noted that running `export GGSASHIMI_DEBUG=yes` (included in the ggsashimi cheatsheet, line 4) has been found to be crucial for the tool's proper behaviour.

In the frame of this cheatsheet, output files are generated and saved under the newly created SashimiPlots folder, inside the working directory.

### 📔 Arguments & Input Files

The ggsashimi cheatsheet requires 2 arguments:

1. `-d $wkDir`: The working directory. The cheatsheet script assumes that the *input file* is located in the working folder, and that it is named `ggsashimi_inputBams.tsv`
2. `-g $gtf`: Path to the GTF file used for the annotation.

The **input file** is a 3-column tsv file containing the following information:

1. Sample ID or name.
2. (Absolute) path to the corresponding BAM file.
3. Group.

An example input file is provided by the ggsashimi developers, [here](https://github.com/guigolab/ggsashimi/blob/master/examples/input_bams.tsv).

</details>

## Immunoinformatics Tools

<details>
<summary>👓 TRUST4</summary>

### 👓 TRUST4

[TRUST4](https://doi.org/10.1038/s41592-021-01142-2) is a computational tool that analyzes TCR and BCR sequences using unselected RNA sequencing data, profiled from **solid tissues**. The installation procedure is straightforward, and it is documented on the correspoding [GitHub repository](https://github.com/liulab-dfci/TRUST4).

The TRUST4 cheatsheet comes with one wrapper script, [TRUST4.run.sh](./src/TRUST4.run.sh) and an additional auxiliary script, [TRUST4.aux_src.CustomAnnotation.sh](./src/TRUST4.aux_src.CustomAnnotation.sh) that creates custom annotation from GTF anf FASTA files specified by the user.

### 👟 Running the Cheatsheet

The TRUST4 cheatsheet assumes that the installation of TRUST4 has taken place in the home folder; thus that the `~/TRUST4/` directory exists and includes all files provided when cloning the [TRUST4 GitHub repo](https://github.com/liulab-dfci/TRUST4).
    
The example provided in this cheatsheet can be run as:

```
sh TRUST4.run.sh -d /working/directory
                 -s "CheatSample"
                 -c true
                 -o Homo_sapiens
	    	 -g /path/to/gtf/annotation/gtf.gtf
                 -f /path/to/fas/annotation/fasta.fa
                 -b /path/to/input/bam.bam
```
    
For more details on the arguments and assumptions of this cheatsheet see [below](-arguments--input-files).

### 📔 Arguments & Input Files

#### 🍨 Main script

7 arguments can be supplied to the TRUST4 main script, but not all of them are required. In more detail:

* `-d $wkDir` (required) : The working directory . The cheatsheet will save the output files in a newly created folder inside the working directory.
* `-s $sample` (required): A sample ID, used for naming the output files. The use of a sample ID is suggested when more than 1 samples are analyzed.
* `-c $custom` (binary, optional): A `true`/`false` argument that specifies whether custom annotation should be generated from input annotation files (see arguments `-g` and `-f`). If the argument is not supplied or is `false` the cheatsheet decides which annotation files to use, depending on the supplied organism/species argument (see below, in additional notes).
* `-o $organism` (required): A string argument supplying the organism/ species name for selection of proper annotation, or creation of custom annotation. A list of possible values for this argument is supplied [here](http://www.imgt.org//download/V-QUEST/IMGT_V-QUEST_reference_directory/), which reflects the availability of reference files that TRUST4 can work with.
* `-g $gtf` (optional): The path to the GTF for the species of interest that will be used for the creation of the custom annotation.
* `-f $fasta` (optional): The path to the FASTA file for the species of interest that will be used in the creation of the custom annotation.
* `-b $bam` (required): The path to the bam file on which TRUST4 will be run. In the frame of this cheatsheet, only the bam input option for TRUST4 is implemented. For more options, see [TRUST4 documentation](https://github.com/liulab-dfci/TRUST4#usage).

A few additional things should be noted:

1. When specifying `-c false -o Homo_sapiens` or `-c false -o Mus_musculus`, the cheatsheet will use the existing annotation that is supplied by the TRUST4 developers.
2. If the organism is neither human nor mouse, the cheatsheet will try to create the custom annotation from the supplied GTF and FASTA. In other words, for species other than human and mouse, the GTF and FASTA files are **required** for the creation of the needed annotation; else the script will exit with error.
3. If a custom annotation exists for the specified organism, the cheatsheet will skip the creation of the custom annotation anew. In order to update the custom annotation, one can delete the existing custom annotation directory (see below) or run the auxiliary script for custom annotation (see below, again).(Note to self: can include an overwrite argument.)

#### 🍬 Auxiliary Scripts

The auxiliary script, [TRUST4.aux_src.CustomAnnotation.sh](./src/TRUST4.aux_src.CustomAnnotation.sh), creates custom annotation from the specified GTF and FASTA files. The output is saved under a newly created directory, located inside the TRUST4 directory (assuming installation at `~/TRUST4/`), named `custom_{Organism}`, based on the species name provided. This can be altered at line 19.

`TRUST4.aux_src.CustomAnnotation.sh` is called by the main script when the `custom` argument is set to `true` and when the custom annotation files do not exist in the expected directory (`~/TRUST4/custom_{Organism}`). If needed, the auxiliary script can be run on its own, for example to update the custom annotation with new GTF or FASTA files. The required arguments are:

* `-o $organism` (required): A string argument supplying the organism/ species name for selection of proper annotation, or creation of custom annotation.
* `-g $gtf` (required): The path to the GTF for the species of interest that will be used for the creation of the custom annotation.
* `-f $fasta` (required): The path to the FASTA file for the species of interest that will be used in the creation of the custom annotation.

The auxiliary script can be run as:
    
```
sh TRUST4.aux_src.CustomAnnotation.sh -o Homo_sapiens
	    	                      -g /path/to/gtf/annotation/gtf.gtf
                                      -f /path/to/fas/annotation/fasta.fa
```
<details>

