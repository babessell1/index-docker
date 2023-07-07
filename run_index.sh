#!/bin/bash

extract_subject_name() {
    # get sample name from cram/bam filename
    local string=$1
    local pattern="([A-Za-z-]+[A-Za-z0-9-]+-[A-Za-z-]+-[A-Za-z0-9]+)"
    local match=""

    if [[ $string =~ $pattern ]]; then
        match="${BASH_REMATCH[1]}"
    fi

    echo "$match"
}


process_file() {
    local cram="$1"

    local fname=$(basename "$fasta")
    local bname=$(basename "$cram" .cram)

    # read only input directories cram/bam, index
    local ro_cram_dir=$(dirname "$cram")
    local ro_cramidx_dir=$(dirname "$cramidx")
    
    # strling requires idx in same folder
    #cp "${ro_cramidx_dir}/${bname}.cram.crai" "${ro_cram_dir}/${bname}.cram.crai"
    samtools index -@ 2 "$cram"
    mv "${ro_cram_dir}/${bname}.cram.crai" "output/${bname}.cram.crai"
}

# command-line (cwl file) arguments
cram1="$1"
cram2="$2"

# out = dir to export to
mkdir -p output
mkdir -p cramsidx

# Run the script in parallel for both cram1 and cram2
(
    process_file "$cram1" "$fasta" "$cramidx1"
) &
(
    process_file "$cram2" "$fasta" "$cramidx2"
) &

# Wait for all parallel processes to finish
wait
name1=$(extract_subject_name "$(basename "$cram1" .cram)")
name2=$(extract_subject_name "$(basename "$cram2" .cram)")

tar cf ${name1}___${name2}.tar output
mv ${name1}___${name2}.tar cramsidx/${name1}___${name2}.tar
