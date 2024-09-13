#!/bin/bash

export REPOS=$HOME"/repos"
mkdir -p $REPOS
cd $REPOS

GastroPak_Workshop=$HOME/repos/GastroPak_Workshop
# ------------------------------
# ----- get all repos ---------- 
# ------------------------------

mkdir -p $HOME/repos
cd $HOME/repos

git clone https://github.com/Sebastien-Raguideau/GastroPak_Workshop.git
git clone --recurse-submodules https://github.com/chrisquince/STRONG.git
git clone https://github.com/chrisquince/genephene.git
git clone https://github.com/rvicedomini/strainberry.git
git clone https://github.com/kkpsiren/PlasmidNet.git


# ------------------------------
# ----- install conda ---------- 
# ------------------------------
cd $HOME/repos
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh

/bin/bash Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p $REPOS/miniconda3 && rm Miniconda3-py38_4.12.0-Linux-x86_64.sh

$HOME/repos/miniconda3/condabin/conda init
$HOME/repos/miniconda3/condabin/conda config --set auto_activate_base false

__conda_setup="$("$HOME/repos/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/repos/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/repos/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/repos/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup


# ------------------------------
# ----- all sudo installs ------
# ------------------------------

sudo apt-get update
# STRONG compilation
sudo apt-get -y install libbz2-dev libreadline-dev cmake g++ zlib1g zlib1g-dev
# bandage and utils
sudo apt-get -y install qt5-default gzip unzip feh evince

# ------------------------------
# ----- Chris tuto -------------
# ------------------------------

cd $HOME/repos/STRONG

# conda/mamba is not in the path for root, so I need to add it
./install_STRONG.sh

# trait inference
mamba env create -f $GastroPak_Workshop/conda_env_Trait_inference.yaml

# trait inference
mamba env create -f $GastroPak_Workshop/Genome_assembly.yaml


# Plasmidnet
mamba create -c anaconda --name plasmidnet python=3.8 -y
export CONDA=$(dirname $(dirname $(which conda)))
source $CONDA/bin/activate plasmidnet
pip install -r $HOME/repos/PlasmidNet/requirements.txt

# -------------------------------------
# -----------Rob Tuto --------------
# -------------------------------------
# --- guppy ---
cd $HOME/repos
wget https://europe.oxfordnanoportal.com/software/analysis/ont-guppy-cpu_5.0.16_linux64.tar.gz
tar -xvzf ont-guppy-cpu_5.0.16_linux64.tar.gz && mv ont-guppy-cpu_5.0.16_linux64.tar.gz ont-guppy-cpu/

# --- everything else ---
mamba env create -f $GastroPak_Workshop/conda_env_LongReads.yaml


# --- Pavian ---
#source /var/lib/miniconda3/bin/activate LongReads
#R -e 'if (!require(remotes)) { install.packages("remotes",repos="https://cran.irsn.fr") }
#remotes::install_github("fbreitwieser/pavian")'

# -------------------------------------
# -----------Seb Tuto --------------
# -------------------------------------

source $CONDA/bin/deactivate


# add R environement
mamba env create -f $GastroPak_Workshop/R.yaml

# add read analysis env
mamba env create -f $GastroPak_Workshop/Read_based_analysis.yaml


# -------------------------------------
# ---------- modify .bashrc -----------
# -------------------------------------

# add -h to ll 
sed -i "s/alias ll='ls -alF'/alias ll='ls -alhF'/g" $HOME/.bashrc 

# add multitude of export to .bashrc
echo -e "\n\n#--------------------------------------\n#------ export path to repos/db -------\n#--------------------------------------">>$HOME/.bashrc

# ---------- add things in path --------------
# guppy install
echo -e "\n\n #------ guppy path -------">>$HOME/.bashrc 
echo -e 'export PATH=~/repos/ont-guppy-cpu/bin:$PATH'>>$HOME/.bashrc

# STRONG install
echo -e "\n\n #------ STRONG path -------">>$HOME/.bashrc 
echo -e 'export PATH=~/repos/STRONG/bin:$PATH '>>$HOME/.bashrc

# Bandage install
echo -e "\n\n #------ guppy path -------">>$HOME/.bashrc 
echo -e 'export PATH=~/repos/Bandage:$PATH'>>$HOME/.bashrc

#  add repos scripts 
echo -e "\n\n #------ GastroPak_Workshop -------">>$HOME/.bashrc
echo -e 'export PATH=~/repos/GastroPak_Workshop/scripts:$PATH'>>$HOME/.bashrc

# add strainberry
echo -e "\n\n #------ strainberry -------">>$HOME/.bashrc 
echo -e 'export PATH=$HOME/repos/strainberry:$PATH'>>$HOME/.bashrc

# add strainberry
echo -e "\n\n #------ plasmidnet -------">>$HOME/.bashrc 
echo -e 'export PATH=$HOME/repos/PlasmidNet/bin:$PATH'>>$HOME/.bashrc


# -------------------------------------
# ---------- add conda  ---------------
# -------------------------------------

###### Install Bandage ######
cd $HOME/repos
wget https://github.com/rrwick/Bandage/releases/download/v0.9.0/Bandage_Ubuntu-x86-64_v0.9.0_AppImage.zip  -P Bandage && unzip Bandage/Bandage_Ubuntu-x86-64_v0.9.0_AppImage.zip -d Bandage && mv Bandage/Bandage_Ubuntu-x86-64_v0.9.0.AppImage Bandage/Bandage


###### add silly jpg ######
cd
wget https://raw.githubusercontent.com/Sebastien-Raguideau/strain_resolution_practical/main/Figures/image_you_want_to_copy.jpg
wget https://raw.githubusercontent.com/Sebastien-Raguideau/strain_resolution_practical/main/Figures/image_you_want_to_display.jpg


# -------------------------------------
# ---------- download datasets  -------
# -------------------------------------
mkdir $HOME/Data
cd $HOME/Data
wget https://microbial-metag-seb-data-sharing.s3.climb.ac.uk/datasets.tar
tar xvf datasets.tar
mv datasets/* .
rm -r datasets datasets.tar


tar xzvf AD16S.tar.gz && mv data AD_16S && rm AD16S.tar.gz && mv metadata.tsv AD_16S&
tar xzvf HIFI_data.tar.gz && rm HIFI_data.tar.gz &
tar xzvf Quince_datasets.tar.gz && mv Quince_datasets/* . && rm Quince_datasets.tar.gz && rm -r Quince_datasets&

# other dataset
mkdir -p $HOME/Data/Genomes/short_read_data
cd $HOME/Data/Genomes/short_read_data
wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/BL23DE3_SR_1.fastq&
wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/BL23DE3_SR_2.fastq&
wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/Ecoli61_SR_paired.fastq&

mkdir -p $HOME/Data/Genomes/long_read_data
cd $HOME/Data/Genomes/long_read_data
wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/BL21DE3_LR.fastq&
wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/Ecoli61_LR.fastq&
wget https://microbial-metag-genome-tutorial.s3.climb.ac.uk/Ecoli61_LR.fastq&


# update db for krona
source $CONDA/bin/activate Read_analysis
cd $CONDA/envs/Read_analysis/opt/krona && ./updateTaxonomy.sh 
source $CONDA/bin/deactivate


# -------------------------------------
# ---------- download databases -------
# -------------------------------------
mkdir -p $HOME/Databases
cd $HOME/Databases

wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20220926.tar.gz
wget https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
wget https://microbial-metag-seb-data-sharing.s3.climb.ac.uk/card_5_10_21.tar.gz

# cogs
wget https://microbial-metag-seb-data-sharing.s3.climb.ac.uk/Cog_LE.tar.gz

# untar
mkdir Cog && tar xzvf Cog_LE.tar.gz -C Cog && rm Cog_LE.tar.gz
mkdir checkm && tar xzvf checkm_data_2015_01_16.tar.gz -C checkm && rm checkm_data_2015_01_16.tar.gz
mkdir kraken && tar xzvf k2_standard_08gb_20220926.tar.gz -C kraken && rm k2_standard_08gb_20220926.tar.gz
tar xzvf card_5_10_21.tar.gz && rm card_5_10_21.tar.gz
rm *.log


# install checkm/gtdb database
source $CONDA/bin/activate Genome_assembly
checkm data setRoot $HOME/Databases/checkm
source $CONDA/bin/deactivate


# -------------------------------------
# ---------- add key   ----------------
# -------------------------------------

# Rob
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOmbDQthXhZ78qqiY85QLzCEl44sZhb6jnatlzoKu+CR0M7VZumWP1LNaI62VaPAuvzSACgwE/9IfSD9YbwVkBPVobYSXyeGb3/JuGiZiErF7bkK4JOpu0K19JogXQCn8CKkFvBwqe4ufaDRch3HGX8MylYwSQViceTPJsGVlCIb5X22+JOFB8uO8Ho1QmTnrRiX1Zw1r/Zw/xT5B+pruMHxE2qGbuKSvZ3okpXwQlyDHw/002GruhQRBb7sMNuRt7fKgZf6/jIH7rbFWlJHtCayDBLK2Y891Ae7ANNfXR8AFPLgLQKsswHOG3/VX4aX6btyKNu2SPXwFDnGFDw63h u1673564@MAC20210
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeEetuKkj9mJ6aK0wRgbPxUWZEVtXiQK856hAVY3fYlK45X6i5wEYT+6/ymIcJ3yDo1Vii3fvYlh46FfNak53Gp8/YOvC/3HQGUR01PfIW1sAdFN6q6EpZ070zkRgp/9E+evTAJkqQ09zueH+Y2o713s4PQMWOnZeDCO5Sksu+5yY5y4Io4hZHPGQYl/M0aG20j44nlWTL1LI1TG4MLMThG2VlZZ8qRnIpvzavLjIXqxgpoYQYEHc9h+KC/ycX5ijahedO/LD2chmk3WoBh8W1SNS4t5dCuT2T9kO0J26uKaWjipm+zoCnO+XJ0AiJGO0TnVh4Z5WMzNbX7D+caQA3b7cG2KwFi8RHk3DxtMaIKhGULEjro0GfoHwbWNdKEyPlpTMlx2NJfUjiJHtWSimHyTHhk7Qg/s7428G+pEYITMFli2jnmRcl7phX9w/gFZHQmEwfkgH065w2p4J65ztDA1rJirNMGO5SZkErJaTQPa1DvudfjglzXhv3HBafcB8= rjames@N120057
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOmbDQthXhZ78qqiY85QLzCEl44sZhb6jnatlzoKu+CR0M7VZumWP1LNaI62VaPAuvzSACgwE/9IfSD9YbwVkBPVobYSXyeGb3/JuGiZiErF7bkK4JOpu0K19JogXQCn8CKkFvBwqe4ufaDRch3HGX8MylYwSQViceTPJsGVlCIb5X22+JOFB8uO8Ho1QmTnrRiX1Zw1r/Zw/xT5B+pruMHxE2qGbuKSvZ3okpXwQlyDHw/002GruhQRBb7sMNuRt7fKgZf6/jIH7rbFWlJHtCayDBLK2Y891Ae7ANNfXR8AFPLgLQKsswHOG3/VX4aX6btyKNu2SPXwFDnGFDw63h u1673564@MAC20210" >> $HOME/.ssh/authorized_keys

# Chris
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC74KXzywTRITuXDFNLklbpKhCHzwTabTZckT/p9r85zUL47mxrhIseFuKORNuX/PpPj9q557zF1Vd3UOi5uItaG35DXgTQF21wauz9N63pFGycbgULBSRrbilcXCUh2/rmaSvpPUb9/rk84q9DgsHthoqH9Fa+omIydZ191ugt//DcY+mmnRpOgNFU/S3zBp2wG/MpI3PEB5b+lFgcS72nr62iSZ3ooPXNkQxR147Hj1T5o7t3HefnNF8cZ4E57Lad3Yw6/UpghDakuGjlcLyjsbTc0KQqIglF7vBGKCcJcVtP6zrCJtTBUSGxLW4a6JqFxxCGANnOn2/pxgrmDjUKkshi0XDDzAm8B1+F/wFq19uogPWFFgjt+d0Xmb/sXl9qRRURZeMpMlA/8c19Xd2XeqTStr0o2MEfHB0z9F9KVZvXUednzuMvqKdteH3eSuYP0g4WHqAfy+xDVTqOApR3I5Z+v/CrSNONkaaW8W1i3uahCpPnPsqrbiaKDVWn4N8vXS85dE48ntjU5to9esC6foDaMtxCW+9K4eGgpsalFV5FeGMb9NOiO1Wbj/ME5n0UyrGx5xAlknrXTAll50drtctqUxKvhjbpdmwe1yX0XdbVp6WLt4IaqSiXmcFnp/M5JN3Rc3hSt8mseQHnWG9xlEGS3HJxpHuIw/c+/v4DjQ== quince@N140667
" >> $HOME/.ssh/authorized_keys



# ---------- put update at the since it takes too long ------------
# metaphlan
source $CONDA/bin/activate Read_analysis
metaphlan --install --bowtie2db $HOME/Databases/metaphlan
source $CONDA/bin/deactivate
