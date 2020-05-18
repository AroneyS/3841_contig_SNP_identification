#!/bin/bash

for f in /input/*.bam
do
    [[ $f =~ \/input\/(.*).bam ]]
    NAME=${BASH_REMATCH[1]}

    samtools sort $f -o /output/${NAME}.sorted
done

samtools faidx /NCBI_3841/3841.fasta -o /NCBI_3841/3841.fasta.fai
samtools faidx /NCBI_3841/prl7.fasta -o /NCBI_3841/prl7.fasta.fai
samtools faidx /NCBI_3841/prl8.fasta -o /NCBI_3841/prl8.fasta.fai
samtools faidx /NCBI_3841/prl9.fasta -o /NCBI_3841/prl9.fasta.fai
samtools faidx /NCBI_3841/prl10.fasta -o /NCBI_3841/prl10.fasta.fai
samtools faidx /NCBI_3841/prl11.fasta -o /NCBI_3841/prl11.fasta.fai
samtools faidx /NCBI_3841/prl12.fasta -o /NCBI_3841/prl12.fasta.fai
