#!/bin/bash

picard CreateSequenceDictionary R=/NCBI_3841/3841.fasta O=/NCBI_3841/3841.dict
picard CreateSequenceDictionary R=/NCBI_3841/prl7.fasta O=/NCBI_3841/prl7.dict
picard CreateSequenceDictionary R=/NCBI_3841/prl8.fasta O=/NCBI_3841/prl8.dict
picard CreateSequenceDictionary R=/NCBI_3841/prl9.fasta O=/NCBI_3841/prl9.dict
picard CreateSequenceDictionary R=/NCBI_3841/prl10.fasta O=/NCBI_3841/prl10.dict
picard CreateSequenceDictionary R=/NCBI_3841/prl11.fasta O=/NCBI_3841/prl11.dict
picard CreateSequenceDictionary R=/NCBI_3841/prl12.fasta O=/NCBI_3841/prl12.dict
