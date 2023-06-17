# Read based  analysis
The point of this tutorial is to go through multiple approaches for read based analysis, namely:

 1. Read profiling with [metaphlan](https://huttenhower.sph.harvard.edu/metaphlan/)
 2. read classification with [kraken](https://github.com/DerrickWood/kraken2/wiki)
 3. [read annotation](https://www.nature.com/articles/s41467-023-36633-7#Sec18) to functional database

## Dataset
Anaerobic digester metagenomic time series subsampled for this tutorial. It is located at :
```bash
cd ~/Data/AD_small
```
Let's have a look at these.

## Taxonomic profiling with metaphlan

We will start with metaphlan. This approach is based on mapping reads to references. 
![metaphlan](/Figures/metaphlan.png)

*Q: About implementation, how would you build such a database if you had to? What are the important points ?*

![metaphlan4](/Figures/metaphlan4.png)
Latest version of metaphlan and uses ~5.1M unique clade-specific marker genes identified from ~1M microbial genomes (~236,600 references and 771,500 metagenomic assembled genomes) spanning 26,970 species-level genome bins

*Q: What happens if a read doesn't map to the extensive database?*

### Using metaphlan 
All dependencies for this practical are installed in the "Read_analysis" conda environment. 

```bash
conda activate Read_analysis
```
Metaphlan uses a database that has been downloaded on the VM. You'll find it at:

    /home/ubuntu/Databases/metaphlan

For the sake of clarity let's work in a dedicated folder:
```bash
mkdir -p ~/Projects/Read_based_analysis/metaphlan 
cd ~/Projects/Read_based_analysis/metaphlan
```

*Practical: You will choose one sample from the data folder and try to use metaphlan to obtain a taxonomic profile. Use either an internet search or the help command (metaphlan -h) to find the correct command line.*

<details><summary> solution</summary>
<p>

```
metaphlan metagenome_1.fastq,metagenome_2.fastq --bowtie2db path_to_metaphlan_db --bowtieout out.bz2 --nproc 5 --input_type fastq -o profiled_metagenome.txt
```
 </p>

*Q: We did the analysis for a unique sample, how would you proceed if you wanted to apply metaphlan to all samples?*

### Results files 

*Q: What does each column means? What are NCBI_tax_id?*

*Practical: Use a series of 2 grep commands to select species level description, the first one selecting for species and the second using the -v option to unselect the non needed lines.*

*Practical2: Run at least another sample and use the command 'merge_metaphlan_tables.py' to merge results into a unique file. Warning, this command generate an output on stdout, you will need to redirect that output.* 

*Practical3: Lets generate a cleaner file, with only species. To do so*
 - use grep to select the header (clade....) and write it to an output file (>)
 - use chained grep command to select only species, but add a third command to the chain, the 'cut' command to remove anything before "|s__"
 - once you have the correct one, redirect output to file in which you wrote the header. Beware that if you don't use >> it will overwrite it.

*Practical4: if we have time, open R, generate a quick heatmap*

## Read classification with kraken2
Kraken uses kmers from reads to allow for fast classification of reads. 

![kmer](/Figures/kmer.png)

*Q: why do we use kmer? How many kmer of size 30 are there?*

![kraken](/Figures/kraken.png)

### Using kraken
As before lets work in a dedicated folder:

```bash
cd ~/Projects/Read_based_analysis 
mkdir kraken
cd kraken
```
*Practical: Use either internet of the -h option when calling kraken to devise the correct command line. You will need to choose a sample from the data folder and you will need the kraken database which is located at:*
 
 ```bash
 /home/ubuntu/Databases/kraken
```
 
<details><summary> solution</summary>
<p>

```
kraken2 --db ~/Databases/kraken R1.fastq R2.fastq --threads 8 --use-names --report report.txt --output sample
```
 </p>
 
### Results

*Q: How many reads have been classified? Why did this happen?*

If using the option --report, we've generated 2 files. Let's have a look at these. There is no header, so making sense of these is not immediate, let's check the [documentation](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown).
 
*Practical: Now that we understand the output, use a simple grep command to select species level classification. *

*Q: How many species is there, ? Why is this different from metaphlan? *

*Q2: How would you merge different reports from different samples?*

We can visualise the kraken report as a Krona plot. 

```bash
cd ~/Projects/Read_based_analysis/kraken
ktImportTaxonomy -q 1 -t 5 kraken_report.txt -o kraken_krona_report.html
```

*Practical: download this html file from the server and open it with your browser. You should obtain something similar to below, but interactive*

![Krona](/Figures/Krona.png)

## Read annotation against CARD with diamond
Sometimes we are more interested on functions than taxonomy, this too can be done at the reads level. Here we are going to use the CARD database to assess level of ARG in these samples. We are re-implementing the method from [here](https://www.nature.com/articles/s41467-023-36633-7#Sec18).

### 1) Diamond

Diamond is approximately blast but faster.
![diamond](/Figures/diamond.png)

In blast and diamond as well, the following convention is used:
![diamond](/Figures/diamond1.png)

*Practical: Devise the correct command line to annotate reads. Use the following options together.*

 - -more--sensitive
 - -e 1.e-10 
 - --id 80
 - --query-cover 70
 - -f6 qseqid sseqid qstart qend qlen sstart send slen length pident evalue bitscore

The database is located at:

    /home/ubuntu/Databases/card_5_10_21/CARD_51021_2.0.8.dmnd

*Q: What does each option used means?*

![coverage](/Figures/cov_explained.png)

### 2) Filtering output

While diamond identify correctly reads similar to database, Some of these hit could be still spurious even after previous filtering options. 
![diamond](/Figures/diamond2.png)

*Q: We want to make sure that any of the flaged card entry is not spuriously so. We want to filter by breadth of coverage on the each card entry. List the steps we need to take to do so.*   

*Practical: use the script filter_breadth_subject.py to filter_out both R1 and R2 files. It is located at:*

    /home/ubuntu/repos/GastroPak_Workshop/scripts/filter_breadth_subject.py

### 3) ARG coverage
*Q: How do we assess the mean depth of coverage? List some simple step you would need to realise to get this information for each CARD entry.*

*Practical: use the script filter_breadth_subject.py to filter_out both R1 and R2 files. It is located at:*

    /home/ubuntu/repos/GastroPak_Workshop/scripts/get_depth_of_coverage.py
