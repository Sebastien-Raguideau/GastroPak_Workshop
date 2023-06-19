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

    mkdir ~/Installed
    cd ~/Installed
    wget https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
    tar zvxf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
    cd MEGAHIT-1.2.9-Linux-x86_64-static/bin/
    sudo cp * /usr/local/bin
    
    
Make analysis folder

    mkdir Projects
    cd Projects/
   
    mkdir GenomeAssembly
    cd GenomeAssembly/

Assembly first genome with megahit:


    megahit -1 ~/Data/Genomes/short_read_data/BL23DE3_SR_1.fastq -2 ~/Data/Genomes/short_read_data/BL23DE3_SR_2.fastq -o BL23DE3_SR_megahit_ -t 8


2023-06-19 17:01:20 - 352 contigs, total 4639286 bp, min 218 bp, max 329790 bp, avg 13179 bp, N50 115146 bp
2023-06-19 17:01:20 - ALL DONE. Time elapsed: 258.170330 seconds


Get average coverage depth 

Get error rate

How would you get summary stats?

Call ORFs with prodigal

Now try spades

    export SRGENOME=~/Data/Genomes/short_read_data

    spades -1 $SRGENOME/BL23DE3_SR_1.fastq -2 $SRGENOME/BL23DE3_SR_2.fastq -o BL23DE3_SR_spades -t 8

In the mean time maybe create kmer histogram plot:
    kat hist -m27 ../BL23DE3_SR_*fastq

This may take twenty minutes or so:

Get assembly stats:

    cd BL23DE3_SR_spades
    
    ~/repos/GastroPak_Workshop/scripts/contig-stats.pl < contigs.fasta 


sequence #: 2244	total length: 5153252	max length: 331988	N50: 82011	N90: 406

Run prodigal to call ORFs

    mkdir annotation
    
    cd annotation    

    prodigal -i ../contigs.fasta -o contigs -a contigs.faa -d contigs.fna

How many genes were found?

Run checkm to evaluate genome

Did you get more genes with spades or megahit

Annotate to CARD?

Visualise assembly graph with Bandage:


# PROKKA genome annotation pipeline

https://github.com/tseemann/prokka

Install:
    mamba install -c conda-forge -c bioconda -c defaults prokka
    

    prokka ../contigs.fasta
    
Visualise with Artemis

    sudo apt install artemis

    art annotation/PROKKA_06192023/PROKKA_06192023.gff 

So cool :)

# Long read assembly