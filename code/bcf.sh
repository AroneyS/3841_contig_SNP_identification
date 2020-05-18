#!/bin/bash

for f in /input/*.sorted
do
    [[ $f =~ \/input\/(.*).sorted ]]
    NAME=${BASH_REMATCH[1]}
    [[ $NAME =~ .*-(.*) ]]
    TYPE=${BASH_REMATCH[1]}

    bcftools mpileup -f /NCBI_3841/${TYPE}.fasta $f | \
        bcftools view -Ov > /input/${NAME}.raw.bcf
done
