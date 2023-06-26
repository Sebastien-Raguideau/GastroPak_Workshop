# R install
We propose to either work with your own computer install of R or use the notebook. If your R version is >4.3 you are fine with working on your laptop. Othewise, just work on the notebook

## Working with the notebook
We are going to install most of the library using conda. The environement definition file is on the github. Let's clone the repos to obtain that file:
```bash
mkdir repos
cd repos
git clone https://github.com/Sebastien-Raguideau/GastroPak_Workshop.git
```

We are then using mamba, which is conda but faster:

```bash
cd ~/repos/GastroPak_Workshop
mamba env create -f R.yaml
```
It may take about ~5min to finish.
Once it is done, don't forget to activate the environment:

    conda activate R_env

We are almost done, one last dependency is missing and we will install it using biocmanager:
Open R by typing `R` in the terminal, then:

    BiocManager::install("miaTime")
