#usage: python filter.py [path] [length of gene] [threshold]
import os, glob
import sys
import linecache

#get arguments 
path = sys.argv[1]
l = int(sys.argv[2])
t = float(sys.argv[3])
print("Converting alignments to fastas")
#open all lastz alignment outputs
seq_one = linecache.getline(path, 1)
print(path, seq_one)
if len(seq_one)> l*t:
    print("Too many gaps disgarding gene")
    with open(path,'w'):
        w.write('')
        #make dict of genes for each species
        