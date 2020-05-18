#!/bin/bash

for f in /NCBI_3841/*.fasta
do
    [[ $f =~ \/NCBI_3841\/(.*).fasta ]]
    NAME=${BASH_REMATCH[1]}

    bowtie2-build $f /output/${NAME}NCBI
done

for f in /input/*.line.fa
do
    [[ $f =~ \/input\/(.*).line.fa ]]
    NAME=${BASH_REMATCH[1]}

    for g in /output/*NCBI*
    do
        [[ $g =~ \/output\/(.*)NCBI ]]
        TYPE=${BASH_REMATCH[1]}

        bowtie2 -f -x /output/${TYPE}NCBI -U $f -S /output/${NAME}-${TYPE}.sam
    done
done
