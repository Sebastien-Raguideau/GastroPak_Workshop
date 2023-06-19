# Genome assembly

Make a new directory in the data folder

    mkdir -p ~/Data/Genomes

    cd ~/Data/Genomes


Then get short read data

    mkdir short_read_data

    cd short_read_data

    wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/BL23DE3_SR_1.fastq
    wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/BL23DE3_SR_2.fastq
    wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/Ecoli61_SR_paired.fastq
    
    cd ..
    
Count number of reads, and total size of files in bps


Then get long read data

    mkdir long_read_data

    cd long_read_data

    wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/BL21DE3_LR.fastq
    wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/Ecoli61_LR.fastq
    wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/Ecoli61_LR.fastq

    cd ..
Count number of reads, and total size of files in bps






Install megahit

   44  wget https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
   45  tar zvxf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
   46  cd MEGAHIT-1.2.9-Linux-x86_64-static/bin/

conda install -c bioconda megahit

conda activate LongReads

sudo cp * /usr/local/bin



megahit -1 BL23DE3_SR_1.fastq -2 BL23DE3_SR_2.fastq -o BL23DE3_SR -t 8


2023-06-19 17:01:20 - 352 contigs, total 4639286 bp, min 218 bp, max 329790 bp, avg 13179 bp, N50 115146 bp
2023-06-19 17:01:20 - ALL DONE. Time elapsed: 258.170330 seconds


Get coverage depth 

Get error rate

How would you get summary stats?

One way



Call ORFs 

Now try spades

spades -1 BL23DE3_SR_1.fastq -2 BL23DE3_SR_2.fastq -o BL23DE3_SR_spades -t 8

~/repos/GastroPak_Workshop/scripts/contig-stats.pl < contigs.fasta 

sequence #: 2244	total length: 5153252	max length: 331988	N50: 82011	N90: 406

Run prodigal to call ORFs

prodigal -i ../contigs.fasta -o contigs -a contigs.faa -d contigs.fna

How many genes were found?

Run checkm to evaluate

Did you get more with spades or megahit

Annotate to CARD?

Flye assembly long reads

Do we want to run prokka pipeline
