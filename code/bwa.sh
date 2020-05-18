#!/bin/bash

for f in /NCBI_3841/*.fasta
do
    bwa index -a is $f
done
