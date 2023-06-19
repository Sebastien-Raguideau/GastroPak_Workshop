# Basics of bioinformatic : Introduction to command lines interface

Bioinformatics rely often on powerful server with more cpu, ram and disk space that your laptop or computer tower can harness. Unfortunately working with distant server imply that you can't use a graphic interface, no mouse no button to press, instead you need to use command lines in a terminal. 

The purpose of this tutorial is to learn again how to do the most basic things such as changing directory, listing files or reading a file. We will also cover the additional powerful features that working in a terminal introduce and in general how to work in a terminal.

## Basic concepts and commands

First of all, the terminal allows you to start a Shell. A Shell is just a program which makes possible for people to interact with the os and in particular with the file system. Different Shell have different syntaxes and commands. 

We are using a Shell called Bash (**B**ourne **a**gain **sh**ell 33 y.o.). 

###  command
A command is a script/program/application .... installed on your device. To use them, you need to type their name followed by argument and options. Example : 

    Command -option argument
All command presented below are always present on bash terminals.  

**List all files and folders** : *ls*

Try to use **ls**.

 A lot of different options are available. Try for yourself  the following : 
 - ls -l
 - ls -lh
 - ls -a
 - ls -alh

From the display (colors) can you identify which names correspond to files and which are folders?


###  Directory structure
When you start the terminal you start an interface with a file system on a distant server. This filesystem is organised in the same way as your computer or laptop.
![tree](/Figures/folder_structure.png)
When you connect you are already somewhere on this tree. You can check where you are with the command: 

```bash
pwd
```

It should give you something like: `/home/jovyan`
It means that you are in the directory jovyan which is itself in the directory home. A special case is that actually the root folder containing all other folder is symbolised only by "/". 

###  Absolute/relative path
When you use the ls command, it will by default list the files in your directory. If you want to list files in another directory, you just need to specify the path to another place as an argument. For instance:

```bash
ls /home
ls /
ls /home/jovyan
```
There are two way to specify a path, either the **absolute path**, it needs to start by "/" and track down all of the parent folder. It can get too long and that is why there is also an alternative notation, the **relative path**.

With  a relative path, you describe the path relatively to where you are presently. 

```bash
ls . # current folder, same as just ls
ls .. # parent folder 
ls /home 
```
Typing 
```bash 
ls ./shared-team 
```
will tell the ls command to look into the folder shared-team, located in the current folder. 
You can chain  these and for instance look 2 folders upward:
```bash 
ls ../../bin 
``` 

###  making mistakes
Type ls followed by an random string of letters:
```bash 
ls ../../wxlcvjqffn
```
You will get an error message.

    ls: cannot access '../../wxlcvjqffn': No such file or directory

**IMPORTANT**: Always read the error message, don't panic, don't ignore it, it tells you what is wrong. Here it says that the path you've given to ls is wrong, and so ls cannot do anything with it. Even if the message is not imediatly clear, you can google it and you should.0

###  Change directory : *cd*

Just type cd following by the path of another directory. Try the following:

```bash 
cd ../../
cd bin
cd /home/jovyan
```

**If you are ever lost just type `cd` and you'll be back to your home folder**


See how your terminal changes. On a typical ubuntu os, you'll see at the start of each line:

*\<username\>@\<hostname\>:\<path\>$*

 - **username** is ... your username
 - **hostanme** is name of your laptop/server/vm ...etc 
 - **path** is the path of the current directory you are in.

On the python notebook only the path is present. You can look at it to know where you are.

When lost about what folder are available, remember to use **ls**. In fact the combo **cd**/**ls** is quite helpful: you move to a directory with **cd** and then you look at the directory content with **ls**. Rinse and repeat.

### Auto-completion
Use the `tab` key to trigger autocompletion, take the habit to use it instead of typing everything,, it helps with mistakes/mistyping. 

*Practical: I created a folder at* `/home/jovyan`, *it is too long and gibberish, but I would like you to look inside, don't copy and paste, don't type, instead use the tab key to do autocomplete*

#### mkdir ~ make directory
mkdir allows you to create whatever directory you want.

```bash
cd /home/jovyan
mkdir this_is_the_best_tutorial_ever`
```

### Dangerous commands
These are the command 99% of people mistyped and removed important file with:

**rm**: remove a file or folder

**mv**: move a file to a new destination, it is how you can rename a file. Issue is that if a file with the same name exist already, you erase it silently.


## Simple files exploration 
**Download a file**
To show what's possible in bash, let's first download a file. You can use the command `wget` to directly download a file, if you know the corresponding url.
Here is an example with and E.Coli genome from ncbi.
```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```
This is a compressed file, we can decompress it with the command:
  ```bash
  gunzip GCF_000005845.2_ASM584v2_genomic.fna.gz
  ```
**Size of a file**
The command du can show the size of file or the space taken by all files in a folders. Multiple options exists. Here we are going to assess the size of the file we just downloaded. The `-m`option means that the size will be in Mo.
 ```bash
du -m GCF_000005845.2_ASM584v2_genomic.fna
```
 **Look into a file**  

How big are this file ? What would happen if you were to try and open it in a text editor?
Look into them by using 
 - less 
 - more 
 - head
 - tail
 
Type q to  quit.

**Number of line in a file** 
*wc -l file*

    wc -l  GCF_000005845.2_ASM584v2_genomic.fna

 
**Search for a pattern**   
*grep pattern file*
**grep** will return any line of the file containing the pattern. 
Lets try to see if we can find some absurds pattern :

    grep GGGGGGGG GCF_000005845.2_ASM584v2_genomic.fna

Which line are they? Lets use the option -n to show the line number corresponding to the pattern.

    grep GGGGGGGG GCF_000005845.2_ASM584v2_genomic.fna -n


##  Working within bash


###  Installing new software: conda
We use a [conda](https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf) env to install all dependencies, you don't need to install anything and all dependencies are available but only inside that environment.
To list all environment create you can type 
```bash
conda env list
```
To install a new software you can add it to the base environment or create a new one with a dedicated name. Let's see how it work with the "cowsays" program.

```bash
conda install -c conda-forge cowpy -n cowsay
```

Try the command `cowpy hello world`
It doesn't work because you need to activate the environment in which the program is installed:

    conda activate cowsay
See how your terminal changed, There is now a (cowsay) pre-pended to your terminal prompt.

Retry the command and enjoy the marvels of bash.    

###  Keeping tasks alive

When closing a terminal, all task started are teminated. This is not optimal, some tasks takes weeks to finish. To solve this issue we work within something called a screen.

Open a screen by typing
```bash
screen -S "chosen screen name"
```
Use the key combination `ctrl+a` to leave the screen and `screen -r` to reopen the chosen screen.

## Advanced Bash
#### wildcards
Wildcard is an advanced way to select multiple files or folder using a pattern. In practice you give incomplete information to bash which will look into all possibilities and output them for you. You use a `* ` symbole, and call it a wildcard.
```bash
ls /home/jovyan/shared-team/*
ls /home/jovyan/*/database
ls /home/jovyan/*/*/*/AD7_W27*
```

#### Writing to a file

A few text editors are available on the terminal, 

 - vim
 - emacs
 - nano

Legend states that after spending a few months learning how to use them , vim and emacs are fantastic text editors!
For everyone else, nano exist.

![tree](/Figures/real_programmers.png)

#### Redirecting an output to a file
All command write on the terminal, this is called, writing to stdout short for standard output. We can instead make to so that a command write this inside a file. It is called: redirecting stdout:
```bash
ls > file.txt # create a new file named file.txt and write output of ls command inside the file
ls >> file.txt # append to a file name file.txt
```
This can be done for any command/program writing in the terminal.

#### chained commands
Sometimes we may want to use multiple command at the same time. To do so we can make it so one command output is given as input to another command. This is called chaining command or piping:
``` bash
ls -l
ls -l |wc -l
```
Here is a practical example:
If you look inside the overly long, rubbish named folder you will see a file named assembly_summary_refseq.txt. It is a summary of refseq genomes references, all metadata and download links. 

Use `less -s` to look at the first few lines

*Practical1: how big is it? how many lines are there? How many columns?*

*Practical2: Use grep to select complete genome (`grep complete <file>` ), chain that command to `wc -l` to know how many there are.*

The **cut** command is allow to parse big tables, and extract some columns of interest. 
```bash
cut assembly_summary_refseq.txt -f1,8,20
head assembly_summary_refseq.txt | cut -f1,8,20
```
Will give columns number 1,8 and 20 which are genome accession, name and download link. 

*Practical3: Use grep to find any ecoli genome and chain it with cut to find their download link*

#### variables
Bash is not just a way to replace the graphic interface and look at file. It is also a language in which you can for instance define variables in the programming sense, a name in which you store information:

```bash
DATA=/home/jovyan/data
```
We just assigned a value to DATA which can now be referred to. Try the following what happens. Also feel free to replace `/home/jovyan/data` by any meaningful path.

The `$` symbol is needed to tell bash that you want to access the value of the variable. 
```bash
    echo $DATA
    mkdir $DATA
    ls $DATA
    cd $DATA
```
 
#### loops
Just like any programming language you can create loops or if conditions. Here let's have an example with loops:
Let's write a simple script which will loop through all files of a folder, and output their size. If you see it takes too long, feel free to interrupt it at any time using key combination ctrl + c

```Bash
	cd /home/jovyan/shared-team/datasets/AD_16S
    for file in ./*.fastq
    do 
    	echo $file
    	du -m $file >> files_sizes.txt
    done
```
- indentation are not required but make the code cleaner.
 - **file** is variable, to access the value of the variable you need to add **$**
 - **echo** is a command used to print a variable, so it is responsible for printing the value of **file** on screen.
 - We use **>>** instead of **>**, it allows to append at the end of a file, while **>**  would recreate a file each time
 

## Practical

We need some datasets for tomorrow tutorial, you need to download the data, put it in the correct folder, unzip it and then use fastqc that you will have installed through conda to check sample quality. 
More in detail:

 - url of the data: https://microbial-metag-seb-data-sharing.s3.climb.ac.uk/AD16S.tar.gz
 - put the dataset in a new folder named `datasets` located in you home directory
 - look on the internet how to use the tar command to decompress the archive
 - url for conda fastqc: https://anaconda.org/bioconda/fastqc 
 - write a bash loop to apply fastqc on each fastq file

 









## To go further
Numerous resources exists on the internet and this tutorial is far from exhaustive. 
Fell free to look for external resources and in particular, [here](https://devhints.io/bash) is an useful bash cheatsheets.
