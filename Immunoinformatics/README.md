# Immuno-informatics Cheatsheets

<summary>👓 TRUST4</summary>

## 👓 TRUST4

[TRUST4](https://doi.org/10.1038/s41592-021-01142-2) is a computational tool that analyzes TCR and BCR sequences using unselected RNA sequencing data, profiled from **solid tissues**. The installation procedure is straightforward, and it is documented on the correspoding [GitHub repository](https://github.com/liulab-dfci/TRUST4).

The TRUST4 cheatsheet comes with one wrapper script, [TRUST4.run.sh](./src/TRUST4.run.sh) and an additional auxiliary script, [TRUST4.aux_src.CustomAnnotation.sh](./src/TRUST4.aux_src.CustomAnnotation.sh) that creates custom annotation from GTF anf FASTA files specified by the user.

### 📔 Arguments & Input Files

7 arguments can be supplied to the TRUST4 wrapper script, but not all of them are required. In more detail:

* `-d $wkDir` (required) : The working directory . The cheatsheet will save the output files in a newly created folder inside the working directory.
* `-s $sample` (required): A sample ID, used for naming the output files. The use of a sample ID is suggested when more than 1 samples are analyzed.
* `-c $custom` (binary, optional): A `true`/`false` argument that specifies whether custom annotation should be generated from input annotation files (see below). If the argument is not supplied or is `false` the cheatsheet decides which annotation files to use, depending on the supplied organism argument (see below).

<details>
    
    
