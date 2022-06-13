# library-of-cheatsheets

A library of example code -aka **cheatsheets**- for tools I use or analyses I carry out pretty often. This repo doubles as an easy way to find the code I need without going through all my scripts.

![Library](/aes/library.jpg)

## 📚 Cheatsheets

In the frame of this repository, a **Cheatsheet** is a collection of commands that runs a specific tool or pipeline from start to end, ensuring an expected behavior. For example, a cheatsheet can include the necessary code for the implementation of an analysis or the generation of a plot. A single cheatsheet usually pertains a specific tool (see `Tools` subfolder), but can be extended to a collection of tools or a pipeline (see `Pipelines` subfolder). 

Each cheatsheet follows the naming conventions below, to ensure better organization of this repo:

* **Cheatsheet main script**: `{name of tool or pipeline}.run.{sh/Rmd/R/ipynb/py}`. This is the main script needed to run the tool or pipeline of interest. All other auxiliary files and scripts are called by the cheatsheet main script. It usually comes in the form of a wrapper script or bash script, an RMarkdown or Rscript, or a Jupyter notebook or Python script, depending on the tools utilized.
* **Auxiliary scripts**: `{name of tool or pipeline}.aux_src.{purpose id of this file}.{sh/Rmd/R/ipynb/py}`. These are scripts that perform specific tasks and are called by the main script. Auxiliary scripts are used in junction with the main script to avoid code clutter in the main script. The auxiliary scripts are standalone entities that can be run on their own if needed.
* **Auxiliary files**: `{name of tool or pipeline}.aux.{id for contents of file}.{txt/tsv/csv/bed...}`.

In effect, one only needs to run the cheatsheet's main script to get the expected output, but the individual auxiliary scripts can be run indipendently if needed.

⚠️ *Disclaimer*: The code for each cheatsheet is optimized in terms of arguments, path architecture, and naming conventions to facilitate my reusing of this code. To facilitate the use of the code by other users, I try to document the adjustments needed as well as provide the appropriate references.

## 🏛️ Repository Architecture

```
├── Pipelines
│   └── GATK_WES
│       └── src
├── Tools
│   ├── aux
│   └── src
└── aes
```
