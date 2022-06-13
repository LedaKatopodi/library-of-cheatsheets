# 🎎 GATK: WES Variant Calling Pipeline

[GATK](https://gatk.broadinstitute.org/hc/en-us) provides the necessary tools and pipelines, and documents the **best practices** for Variant Discovery in High-Throughput Sequencing Data (WGS, WES, and RNAseq). The purpose of this cheatsheet is to gather together the GATK-proposed best practices for WES Variant Calling into a single pipeline. The cheatsheet is split into 3 parts; 1 initial/optional and 2 main steps.

The cheatsheet was built and tested with the following module versions:

* gatk/4.1.3.0
* bwa/0.7.8
* samtools/1.9
* conda2/4.2.13
* vep/98.3

🍡 Best practices for germline variant calling were adopted, as described [here](https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels-).

🍡 Best practices for somatic variant calling were adopted, as described [here](https://gatk.broadinstitute.org/hc/en-us/articles/360035894731-Somatic-short-variant-discovery-SNVs-Indels-).

## 👟 Running the Cheatsheet

The cheatsheet is split into 3 parts:

0. Download of GATK Resource files
1. Variant Calling
2. Variant Filtering and Annotation

To run the whole cheatsheet:

```
sh GATK_WES.run.sh -c variant_calling_step_true/false \
                   -f variant_filtering_step_true/false \
                   -r download_gatk_res_true/false \
                   -d /working/directory \
                   -m ucsc_to_ncbi_true/false \
                   -n "Sample1" \
                   -1 sample1.R1.fastq.gz \
                   -2 sample1.R2.fastq.gz \
                   -g germline_true/false \
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

At this step the following resources from GATK are downloaded:
* AF gnomAD VCF: AF-containing VCF, used to exclude regions around known polymorphisms. [Link to file](https://console.cloud.google.com/storage/browser/_details/gatk-best-practices/somatic-hg38/af-only-gnomad.hg38.vcf.gz;tab=live_object).
* HapMap VCF: a resource of validated known sites of common variation. [Link to file](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz;tab=live_object).
* Mills VCF: a resource of validated known sites of common variation. [Link to file](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz;tab=live_object).
* AF-only biallelic sites VCF: AF-only-containing VCF file of known polymorphisms. [Link to file](https://console.cloud.google.com/storage/browser/_details/gatk-best-practices/somatic-hg38/small_exac_common_3.hg38.vcf.gz;tab=live_object).

Auxiliary script for this step: `GATK_WES.aux_src.GATK_Resources.sh`

The script can be run on its own as:

```
sh GATK_WES.aux_src.GATK_Resources.sh -d working/directory \
	                                    -m ucsc_to_ncbi_true/false
```

### 🪀 1. Variant Calling

Variant calling on WES libraries can be performed in germline and/or somatic mode, following the GATK best practices for both sample types. More specifically, the variant calling part of the analysis consists of the following:

* Alignment to the reference genome with _BWA mem_.
* Duplication marking and Base Recalibration
* Variant calling:
  * For the Germline samples: Variant calling with _Haplotype Caller_.
  * For the Somatic samples: Variant calling with _Mutect2_

Auxiliary script for this step: `GATK_WES.aux_src.VariantCalling.sh`

The script can be run on its own as:

```
sh GATK_WES.aux_src.VariantCalling.sh -d working/directory \
	                                    -n "SampleID" \
                                      -1 sample1.R1.fastq.gz \
                                      -2 sample1.R2.fastq.gz \
                                      -g germline_true/false \
                                      -s somatic_true/false \
```

⚠️ The script assumes a reference FASTA file, `{working directory}/aux/Homo_sapiens.GRCh38.dna.primary_assembly.fa` (Homo sapiens GRCh38, Ensembl v98). The path can be modified at line 25 of `GATK_WES.aux_src.VariantCalling.sh`.
⚠️ The script assumes that the auxiliary af-gnomad file is under `{working directory}/GATKResources`, the directory created when running _Step 0: Download GATK Resources_ of the pipeline. The path can be modified at line 24 of `GATK_WES.aux_src.VariantCalling.sh`.

### 🪅 2. Variant Filtering

Different variant filtering approaches are adopted for the germline and somatic samples.

For the germline, specifically, a [conda environment has to be setup](https://gatk.broadinstitute.org/hc/en-us/articles/360035889851--How-to-Install-and-use-Conda-for-GATK4).

Fitlered variants (germline or somatic) are annotated with VEP.

Auxiliary script for this step: `GATK_WES.aux_src.VariantFiltering.sh`

The script can be run on its own as:

```
sh GATK_WES.aux_src.VariantFiltering.sh -d working/directory \
	                                    -n "SampleID" \
                                      -g germline_true/false \
                                      -s somatic_true/false \
```

⚠️ The script assumes a reference FASTA file, `{working directory}/aux/Homo_sapiens.GRCh38.dna.primary_assembly.fa` (Homo sapiens GRCh38, Ensembl v98). The path can be modified at line 27 of `GATK_WES.aux_src.VariantFiltering.sh`.
⚠️ The script assumes that the auxiliary af-gnomad, HapMap, Mills, and AF-only-biallelic VCF files (see [above](0-dDownload-gatk-resources) are under `{working directory}/GATKResources`, the directory created when running _Step 0: Download GATK Resources_ of the pipeline. The paths can be modified at lines 26, 28, 29, and 30 of `GATK_WES.aux_src.VariantFiltering.sh`.
