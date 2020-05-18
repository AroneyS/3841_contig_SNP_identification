#!/bin/bash

for f in /input/*.bam
do
    [[ $f =~ \/input\/(.*).bam ]]
    NAME=${BASH_REMATCH[1]}

    samtools sort $f -o /output/${NAME}.sorted
done

for f in /NCBI_3841/*.fasta
do
    samtools faidx $f -o ${f}.fai
done
