#!/bin/bash

###################################
### Setup files, split by 1000s ###
###################################

# Remove '>' sections and combine lines within each section
for f in ./contigs/*.fasta ; do sed 's/^>NODE.*$/>/g' $f > $f\_clean ; done ;
for f in ./contigs/*_clean ; do cat $f | tr -d '\n' > $f\_comb ; done ;

for f in ./contigs/*_comb
do
    sed -i 's/>/\n/g' $f
    sed -i 1d $f
done

# Remove first and last 1000bp from each line (and all contigs <2000bp)
for f in ./contigs/*_comb
do
    awk '{length($0)>2000}{print substr($0, 1000, length($0)-2000)}' $f > \
            $f\_trim
done
for f in ./contigs/*_trim ; do sed -i '/^$/d' $f ; done ;

# Split lines into groups of 1000
for f in ./contigs/*_trim ; do sed -r 's/(.{1000})/\1\n/g' $f > $f\_every1000 ; done ;

# Label each line with read_{filename}_{num}
for f in ./contigs/*_every1000
do
    [[ $f =~ \/contigs\/(.*)\.fasta.* ]]
    NAME=${BASH_REMATCH[1]}
    cat $f | \
        awk '{printf "%d\n%s\n", NR, $0}' | \
        sed "/^[0-9]/s/^/>contig_$NAME\_/" > \
        ./contigs/${NAME}.line.fa
done

rm ./contigs/*_clean ; rm ./contigs/*_comb ; rm ./contigs/*_trim ; rm ./contigs/*_every1000 ;

#############################################
### Run applications in docker containers ###
#############################################
# Each container has an individual shell file
# Interactive: docker run -it {container} bash

# Run each stage for genome, pRL7-12
# Generate NCBI 3841 build and align isolates
mkdir bt2_out
docker run \
    -v `pwd`/code:/code \
    -v `pwd`/contigs:/input \
    -v `pwd`/NCBI_3841:/NCBI_3841 \
    -v `pwd`/bt2_out:/output \
    biocontainers/bowtie2:v2.3.4.3-1-deb_cv2 \
    /code/bt2.sh

# Convert to bam files
mkdir sam_out
docker run \
    -v `pwd`/code:/code \
    -v `pwd`/bt2_out:/input \
    -v `pwd`/sam_out:/output \
    biocontainers/samtools:v1.9-4-deb_cv1 \
    /code/sam1.sh

# BWA index
docker run \
    -v `pwd`/code:/code \
    -v `pwd`/NCBI_3841:/NCBI_3841 \
    biocontainers/bwa:v0.7.17-3-deb_cv1 \
    /code/bwa.sh

# Picard
docker run \
    -v `pwd`/code:/code \
    -v `pwd`/NCBI_3841:/NCBI_3841 \
    biocontainers/picard:v2.3.0_cv3 \
    /code/picard.sh

# Samtools sort and faidx (index reference sequence)
mkdir align_out
docker run \
    -v `pwd`/code:/code \
    -v `pwd`/sam_out:/input \
    -v `pwd`/align_out:/output \
    -v `pwd`/NCBI_3841:/NCBI_3841 \
    biocontainers/samtools:v1.9-4-deb_cv1 \
    /code/sam2.sh

# BCFtools mpileup and view to generate raw alignments
docker run \
    -v `pwd`/code:/code \
    -v `pwd`/align_out:/input \
    -v `pwd`/NCBI_3841:/NCBI_3841 \
    biocontainers/bcftools:v1.9-1-deb_cv1 \
    /code/bcf.sh

for f in ./align_out/*.raw.bcf
do
    [[ $f =~ \/align_out\/(.*).raw.bcf ]]
    NAME=${BASH_REMATCH[1]}

    grep -P [A,C,G,T]'\t'[A,C,G,T] $f | \
        sed "s/^/${NAME}\t/" > \
        ./align_out/${NAME}_SNP
done

cat ./align_out/*_SNP > SNP_table.tsv

#################################
### Remove intermediate files ###
#################################
rm -r bt2_out
rm -r sam_out
rm -r align_out
rm ./contigs/*line*
rm ./NCBI_3841/*.fasta.*
rm ./NCBI_3841/*.dict
