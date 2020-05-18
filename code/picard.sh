#!/bin/bash

for f in /NCBI_3841/*.fasta
do
    [[ $f =~ \/NCBI_3841\/(.*).fasta ]]
    NAME=${BASH_REMATCH[1]}
    
    picard CreateSequenceDictionary R=$f O=/NCBI_3841/${NAME}.dict
done
