#!/usr/bin/env bash
# Set bash strict mode (fail on errors, undefined variables, and via pipes)
set -euxo pipefail

SAMPLE_DATA_DIR="sample_data"

if [ ! -d ${SAMPLE_DATA_DIR} ]; then
    mkdir ${SAMPLE_DATA_DIR}
fi

if [[ -x "$(command -v wget)" ]]; then
    printf "INFO:\tDownloading files using wget."
    FETCH="wget"
elif [[ -x "$(command -v curl)" ]]; then
    echo "INFO:\tDownloading files using curl"
    FETCH="curl -O"
else
    printf "ERROR: Failed to find wget or curl"
    exit 1
fi

printf "===================================="
printf "Fetching Escherichia coli K-12 files"
printf "===================================="

cd ${SAMPLE_DATA_DIR}

# Note: These files are legacy.
${FETCH} ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.gbk
${FETCH} ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.fna
${FETCH} ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.ffn
${FETCH} ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa

printf "=========================================================="
printf "Fetching proteins from Potato Genome Sequencing Consortium"
printf "=========================================================="

${FETCH} http://potato.plantbiology.msu.edu/data/PGSC_DM_v3.4_pep_representative.fasta.zip
unzip -o PGSC_DM_v3.4_pep_representative.fasta.zip

printf "===================================="
printf "Fetching PF08792 alignment from PFAM"
printf "===================================="

if [[ -x "$(command -v wget)" ]]; then
  wget -O "PF08792_seed.sth" http://pfam.sanger.ac.uk/family/PF08792/alignment/seed/format?format=stockholm
elif [[ -x "$(command -v curl)" ]]; then
  curl -o "PF08792_seed.sth" -L http://pfam.sanger.ac.uk/family/PF08792/alignment/seed/format?format=stockholm
else
  printf "ERROR:\tFailed to find wget or curl"
  exit 1
fi


cd ..