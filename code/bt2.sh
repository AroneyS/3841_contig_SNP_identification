#!/bin/bash

bowtie2-build /NCBI_3841/3841.fasta /output/3841NCBI
bowtie2-build /NCBI_3841/prl7.fasta /output/prl7NCBI
bowtie2-build /NCBI_3841/prl8.fasta /output/prl8NCBI
bowtie2-build /NCBI_3841/prl9.fasta /output/prl9NCBI
bowtie2-build /NCBI_3841/prl10.fasta /output/prl10NCBI
bowtie2-build /NCBI_3841/prl11.fasta /output/prl11NCBI
bowtie2-build /NCBI_3841/prl12.fasta /output/prl12NCBI

for f in /input/*.line.fa
do
    [[ $f =~ \/input\/(.*).line.fa ]]
    NAME=${BASH_REMATCH[1]}

    bowtie2 -f -x /output/3841NCBI -U $f -S /output/${NAME}-3841.sam
    bowtie2 -f -x /output/prl7NCBI -U $f -S /output/${NAME}-prl7.sam
    bowtie2 -f -x /output/prl8NCBI -U $f -S /output/${NAME}-prl8.sam
    bowtie2 -f -x /output/prl9NCBI -U $f -S /output/${NAME}-prl9.sam
    bowtie2 -f -x /output/prl10NCBI -U $f -S /output/${NAME}-prl10.sam
    bowtie2 -f -x /output/prl11NCBI -U $f -S /output/${NAME}-prl11.sam
    bowtie2 -f -x /output/prl12NCBI -U $f -S /output/${NAME}-prl12.sam
done