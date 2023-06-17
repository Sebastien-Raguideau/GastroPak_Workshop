#!/usr/bin/env python3
from Bio.SeqIO.FastaIO import SimpleFastaParser as sfp
from collections import Counter, defaultdict
from operator import itemgetter
import numpy as np
import argparse
import os

# merge a list of intervals  quickly : https://stackoverflow.com/questions/52073609/get-unions-and-intersections-of-list-of-datetime-ranges-python
def union(intervals):
    sorted_intervals = sorted([tuple(sorted(i)) for i in intervals], key=itemgetter(0))
    if len(sorted_intervals)<=1:  # no intervals to merge
        yield sorted_intervals[0][0],sorted_intervals[0][1]
        return
    # low and high represent the bounds of the current run of merges
    low, high = sorted_intervals[0]
    for iv in sorted_intervals[1:]:
        if iv[0] <= high:  # new interval overlaps current run
            high = max(high, iv[1])  # merge with the current run
        else:  # current run is over
            yield low, high  # yield accumulated interval
            low, high = iv  # start new run
    yield low, high  # end the final run

parser = argparse.ArgumentParser()
parser.add_argument("m6", help="input m6 file")
parser.add_argument("out", help="output file")
parser.add_argument("-f", help="minimum subject breadth of coverage",default=0.8)
args = parser.parse_args()

m6_file = args.m6
output_file = args.out
threshold = float(args.f)



### I) for each subject (card entry) store all sstart/send

# create a dictionary object which will store the list of all reads associated to each card entry 
card_to_reads = defaultdict(list)

# create a dictionary object which will store the length of each CARD entry
card_to_length = defaultdict(list)

for line in open(m6_file):
	# split line by tabulations, and get all fields 
	querry, subject, qstart, qend, qlen, sstart, send, slen, AL, Pid, evalue, bitscore = line.rstrip().split()
	# store the information of where the querry (read) mapped onto the subject (card entry)
	card_to_reads[subject].append([int(sstart),int(send)])
	# store the length of each card entry
	card_to_length[subject] = int(slen)




### II) loop over each card entry, and use the union function to obtain the merged interval
# create a dictionary object which will store the list of all intervals
card_to_intervals = defaultdict(list)

for card, read_intervals in card_to_reads.items():
	# union is a generator and need to be handled as if it was a list
	for interval in union(read_intervals):
		card_to_intervals[card].append(interval)

### III) calculate breadth of coverage
# create an empty set in which we put the card entry wich do not pass the threshold
to_filter_out = set()

# for each card entry, sum the interval lengths, then compare to card entry length
for card, intervals in card_to_intervals.items():
	# sum the intervals lengths
	total_covered = 0
	for start,end in intervals:
		total_covered += end-start
	# calculate breadth of coverage
	breadth_of_coverage = total_covered/card_to_length[card]
	if breadth_of_coverage < threshold:
		to_filter_out.add(card)

### IV) output filtered input file
# simply go through each line, if the card entry is filtered out, don't print it:
with open(output_file,"w") as handle:
	for line in open(m6_file):
		querry, subject, qstart, qend, qlen, sstart, send, slen, AL, Pid, evalue, bitscore = line.rstrip().split()
		if subject not in to_filter_out:
			handle.write(line)
