#!/bin/bash
set -uo pipefail

bam_folder=$1
tmp_folder=$2
out_folder=$3
sample=$4

for chr in chr1A chr1B chr1D chr2A chr2B chr2D chr3A chr3B chr3D chr4A chr4B chr4D chr5A chr5B chr5D chr6A chr6B chr6D chr7A chr7B chr7D ;do
    /data2/user2/niujx/software/bedtools coverage -a ../bed/${chr}.1.100k.bed -b ${bam_folder}/${chr}.1.dedup.bam -counts -sorted > ${tmp_folder}/${sample}.${chr}.1.100k.DP
    /data2/user2/niujx/software/bedtools coverage -a ../bed/${chr}.2.100k.bed -b ${bam_folder}/${chr}.2.dedup.bam -counts -sorted > ${tmp_folder}/${sample}.${chr}.2.100k.DP 
    gawk '{print $4*1000/($3-$2)}' ${tmp_folder}/${sample}.${chr}.1.100k.DP > ${tmp_folder}/${sample}.${chr}.1.100k.tmp
    gawk '{print $4*1000/($3-$2)}' ${tmp_folder}/${sample}.${chr}.2.100k.DP > ${tmp_folder}/${sample}.${chr}.2.100k.tmp
done
wait

    cat ${tmp_folder}/${sample}.chr*.100k.tmp > ${tmp_folder}/${sample}.combine_100k_DP
    ave=`awk '{ if ($1 != 0) print $1 }' ${tmp_folder}/${sample}.combine_100k_DP | sort | uniq -c | sort -nr | head -n1 | awk '{printf "%.2f\n", $2}'`

for chr in chr1A chr1B chr1D chr2A chr2B chr2D chr3A chr3B chr3D chr4A chr4B chr4D chr5A chr5B chr5D chr6A chr6B chr6D chr7A chr7B chr7D ;do
    gawk -vOFS="\t" -vave=$ave '{print $1/ave}' ${tmp_folder}/${sample}.${chr}.1.100k.tmp  > ${tmp_folder}/${sample}.${chr}.norm
    gawk -vOFS="\t" -vave=$ave '{print $1/ave}' ${tmp_folder}/${sample}.${chr}.2.100k.tmp  >> ${tmp_folder}/${sample}.${chr}.norm
done

for chr in chrUn2-chr1A chrUn2-chr1B chrUn2-chr1D chrUn2-chr2A chrUn2-chr2B.1 chrUn2-chr2B.2 chrUn2-chr2D chrUn2-chr3A chrUn2-chr3B chrUn2-chr3D chrUn2-chr4A chrUn2-chr4B chrUn2-chr5A chrUn2-chr5B chrUn2-chr5D chrUn2-chr6A chrUn2-chr6B chrUn2-chr6D chrUn2-chr7A chrUn2-chr7B chrUn2-chr7D ;do
    /data2/user2/niujx/software/bedtools coverage -a ../bed/${chr}.bed -b ${bam_folder}/${chr}.dedup.bam -counts -sorted > ${tmp_folder}/${sample}.${chr}.DP
    gawk '{print $4*1000 / ($3 - $2 + 1)}' ${tmp_folder}/${sample}.${chr}.DP > ${tmp_folder}/${sample}.${chr}.tmp
    gawk -vOFS="\t" -vave=$ave '{print $1/ave}' ${tmp_folder}/${sample}.${chr}.tmp  > ${tmp_folder}/${sample}.${chr}.norm
done

if [ -e "${out_folder}/${sample}.CNVb" ]; then
    rm "${out_folder}/${sample}.CNVb"
fi
for chr in chr1A chr1B chr1D chr2A chr2B chr2D chr3A chr3B chr3D chr4A chr4B chr4D chr5A chr5B chr5D chr6A chr6B chr6D chr7A chr7B chr7D chrUn2-chr1A chrUn2-chr1B chrUn2-chr1D chrUn2-chr2A chrUn2-chr2B.1 chrUn2-chr2B.2 chrUn2-chr2D chrUn2-chr3A chrUn2-chr3B chrUn2-chr3D chrUn2-chr4A chrUn2-chr4B chrUn2-chr5A chrUn2-chr5B chrUn2-chr5D chrUn2-chr6A chrUn2-chr6B chrUn2-chr6D chrUn2-chr7A chrUn2-chr7B chrUn2-chr7D ;do
   awk '{if ($1 <= 0.5) print "deletion";else if ($1>=1.5) print "duplication";else print "white"}' ${tmp_folder}/${sample}.${chr}.norm > ${tmp_folder}/${sample}.${chr}.norm.tmp
   paste ../bed/${chr}.bed ${tmp_folder}/${sample}.${chr}.norm.tmp | sed 's/ /\t/g'> ${tmp_folder}/${sample}.${chr}.CNVb
   cat ${tmp_folder}/${sample}.${chr}.CNVb >> ${out_folder}/${sample}.CNVb
done
