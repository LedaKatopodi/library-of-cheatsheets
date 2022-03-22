# library-of-cheatsheets

A library of various tools I use *pwetty often*. This repo doubles as an easy way to find the code I need without going through all my scripts.

![Library](/aes/library.jpg)

## 📚 Cheatsheets

In the frame of this repository, a **Cheatsheet** is a collection of commands that ensures an expected behavior, e.g. the implementation of an analysis or the generation of a plot. A single cheatsheet usually pertains a single tool, but can be extended to a collection of tools or a pipeline. Each cheatsheet contains at least one wrapper script and, possibly, additional auxiliary files or scripts. The wrapper file contains all primary and secondary code/commands needed to run each tool or pipeline and produce the desired effect; in effect, one only needs to run the wrapper script to get the expected output. 

Each cheatsheet follows the naming conventions below, to ensure better organization of this repo:

* **Wrapper script**: `{name of cheatsheet}.run.{appropriate extension}`. As mentioned above, one only needs to run this script to produce the desired output. All other auxiliary files and scripts are supplied to the wrapper script.
* **Auxiliary scripts**: `{name of cheatsheet}.aux_src.{purpose id of this file}.{appropriate extension}`.
* **Auxiliary files**: `{name of cheatsheet}.aux.{id for contents of file}.{appropriate extension}`.

*Disclaimer*: The code in each cheatsheet is optimized in terms of arguments, path architecture, and naming conventions to facilitate my reusing of this code. To facilitate the use of the code by other users, I try to document the adjustments needed as well as provide the appropriate references.

## 🏛️ Repository Architecture

The repository is split in sub-folders based on the "end-goal" of each cheatsheet, i.e. what type of analysis is carried out by each cheatsheet.

```
.
├── Immunoinformatics
│   └── src
├── Plotting
│   ├── aux
│   └── src
└── aes
```
