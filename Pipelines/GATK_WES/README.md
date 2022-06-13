# 🎎 GATK: WES Variant Calling Pipeline

[GATK](https://gatk.broadinstitute.org/hc/en-us) is a collection of **best practices** documentation, tools and pipelines for Variant Discovery in High-Throughput Sequencing Data (WGS, WES, and RNAseq). The purpose of this cheatsheet is to gather together the GATK-proposed best practices for WES Variant Calling into a single pipeline. The cheatsheet is split into 3 parts; 1 initial/optional and 2 main steps.

The cheatsheet was built and tested with the following module versions:

* gatk/4.1.3.0
* samtools/1.9
* vep/98.3

## 👟 Running the Cheatsheet

The cheatsheet is split into 3 parts:

0. Download of GATK Resource files
1. Variant Calling
2. Variant Filtering and Annotation

To run the whole cheatsheet:

```
sh GATK_WES.run.sh -c variant_calling_step_true/false
                   -f variant_filtering_step_true/false
                   -r download_gatk_res_true/false
                   -d /working/directory
                   -m ucsc_to_ncbi_true/false
                   -n "Sample1"
                   -1 sample1.R1.fastq.gz
                   -2 sample1.R2.fastq.gz
                   -g germline_true/false
                   -s somatic_true/false

```
                   
<details>
<summary>Details on the arguments:</summary> 
  
The table below documents the usage and description of the arguments. The 4 last columns depict whether a specific argument is needed for the particular script/pipeline step.
  
| argument | description | Main cheatsheet | Step 0 script | Step 1 script | Step 2 script |
|---| --- | --- | --- | --- |  --- |
| `-c` | true/false: Perform variant calling | ✔️ | ❌ | ❌ | ❌ |
| `-f` | true/false: Pperform variant filtering | ✔️ | ❌ | ❌ | ❌ |
| `-r` | true/false: Download GATK resources | ✔️ | ❌ | ❌ | ❌ |
| `-d` | Path to working directory | ✔️ | ✔️ | ✔️ | ✔️ |
| `-m` | true/false: Modify GATK resource files from UCSC to NCBI format ("chr1" vs "1") | ✔️ | ✔️ | ❌ | ❌ |
| `-n` | Sample name or ID | ✔️ | ❌ | ✔️ | ✔️ |
| `-1` | R1 FASTQ input file | ✔️ | ❌ | ✔️ | ❌ |
| `-2` | R1 FASTQ input file | ✔️ | ❌ | ✔️ | ❌ |
| `-g` | true/false: Run pipeline in Germline mode (for Germline samples) | ✔️ | ❌ | ✔️ | ✔️ |
| `-s` | true/false: Run pipeline in Somatic mode (for Somatic samples) | ✔️ | ❌ | ✔️ | ✔️ |

</details>

## 📚 Auxiliary Scripts

### ☎️ 0. Download GATK Resources


