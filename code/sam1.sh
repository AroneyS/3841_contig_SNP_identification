#!/bin/bash

for f in /input/*.sam
do
    [[ $f =~ \/input\/(.*).sam ]]
    NAME=${BASH_REMATCH[1]}

    samtools view -bS $f > /output/${NAME}.bam
done
