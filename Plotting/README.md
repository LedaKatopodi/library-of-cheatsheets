# Plotting Cheatsheets
<details>
<summary><a>## 🍣 ggsashimi</a></summary>

## 🍣 ggsashimi

[ggsashimi](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1006360) is a plotting tool developped by the Guigo lab for the visualization of alternative splicing events. The installation procedure is well documented on their [GitHub page](https://github.com/guigolab/ggsashimi), along with the dependencies. For this cheatsheet the following modules were imported:

* Python/3.6
* R/4.0.1
	* ggplot2/3.3.5
	* data.table/1.14.2
	* gridExtra/2.3

The ggsashimi cheatsheet comes with a single wrapper script, [ggsashimi.run.sh](./src/ggsashimi.run.sh).

### 📔 Arguments & Input Files

The ggsashimi cheatsheet requires 2 arguments:

1. `-d $wkDir`: The working directory. The cheatsheet script assumes that the *input file* is located in the working folder, and that it is named `ggsashimi_inputBams.tsv`
2. `-g $gtf`: Path to the GTF file used for the annotation.

The **input file** is a 3-column tsv file containing the following information:

1. Sample ID or name.
2. (Absolute) path to the corresponding BAM file.
3. Group.

An example input file is provided by the ggsashimi developers, [here](https://github.com/guigolab/ggsashimi/blob/master/examples/input_bams.tsv).

### 👟 Running the Cheatsheet

The ggsashimi cheatsheet was built under the following additional constraints/assumptions:

* The ggsashimi source code is located in the home folder, under `~/ggsashimi.py`. The user can adjust accordingly (line 22).
* For the purposes of this cheatsheet demonstration, the wrapper script contains example code for plotting the splicing events on the PIANP gene (hg38). The coordinates for the example gene are specified by the `-c` argument when running ggsashimi; the output name is specified by the `--out-prefix` argument. The user can adjust accordingly (lines 22 and 23, respectively).
* For the purposes of this cheatsheet demonstration, the wrapper script assumes 2 groups, thus generates a palette of 2 colors. The user can adjust accordingly (line 20). (Note to self: although automatic generation of the color palette goes beyond the scope of this cheatsheet, it would be a nice automation.)

That being said, the example provided in this cheatsheet can be run as:

```
sh ggsashimi.run.sh /working/directory /path/to/gtf/annotation/gtf.gtf
```
⚠️ It should also be noted that running `export GGSASHIMI_DEBUG=yes` (included in the ggsashimi cheatsheet, line 4) has been found to be crucial for the tool's proper behaviour.

In the frame of this cheatsheet, output files are generated and saved under the newly created SashimiPlots folder, inside the working directory.
</details>
