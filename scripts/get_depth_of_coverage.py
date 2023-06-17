#!/usr/bin/env python3
from Bio.SeqIO.FastaIO import SimpleFastaParser as sfp
from collections import Counter, defaultdict
from operator import itemgetter
import numpy as np
import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("m6", help="input m6 file")
parser.add_argument("out", help="output file")
args = parser.parse_args()

m6_file = args.m6
output_file = args.out

### I) for each subject (card entry) sum all alignment length

# create a dictionary object which will store the total alignment length 
card_to_AL = defaultdict(int)
# create a dictionary object which will store the length of each CARD entry
card_to_length = defaultdict(list)

for line in open(m6_file):
	# split line by tabulations, and get all fields 
	querry, subject, qstart, qend, qlen, sstart, send, slen, AL, Pid, evalue, bitscore = line.rstrip().split()
	# store the information of where the querry (read) mapped onto the subject (card entry)
	card_to_AL[subject]+=int(AL)
	# store the length of each card entry
	card_to_length[subject] = float(slen)

### II) calculate mean depth of coverage

card_to_cov = defaultdict(float)
for card,AL_tot in card_to_AL.items():
	# calculate the mean
	card_to_cov[card] = AL_tot/card_to_length[card]

### III) output the result
with open(output_file,"w") as handle:
	for card,cov in card_to_cov.items():
		handle.write("%s\t%s\n"%(card,cov))


