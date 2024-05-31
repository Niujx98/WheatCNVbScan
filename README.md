# WheatCNVbScan
WheatCNVbScan is a command line tool for rapid, multi-sample copy number variation blocks (CNVb) identification. It obtains the read depth for each bin of the genome based on bam files and outputs it in CNVb file format, which can be used for CNVb marker scanning.

## System Requirements
reference dependencies: In order to facilitate further scanning of CNVb markers, the specified reference genome WheatPanGenome.tar.gz provided by the WheatCNVb database should be used during resequencing alignment. The download link is http://wheat.cau.edu.cn/WheatCNVb/data/WheatPanGenome.tar.gz.

## Installation
WheatCNVbScan is a light weight software that only need to make sure bedtools v2.26.0 is well installed and set in environment path.

Clone the WheatCNVbScan repository
```
git clone https://github.com/niujx98/WheatCNVbScan.git
```

## Usage
The following command will create a CNVb file :
```
./WheatCNVbScan.sh <bam_folder> <tmp_folder> <out_folder> <sample>

    -bam_folder: The directory path storing .bam files.
    -tmp_folder: The directory path for storing temporary files.
    -out_folder: The directory path for storing output files.
    -sample: The name of the sample, used for naming the output file.

```

## Output Explanation
The output file includes four columns, below is an example of the format for the CNVb(.rd) file.

```
chromosome  start_position  end_position    CNVb_Status
chr1A	0	100000	deletion
chr1A	100000	200000	deletion
chr1A	200000	300000	white
chr1A	300000	400000	duplication

```

## Quickstart with an example
Try running the following command in the test folder to attempt.
```
   sh ../src/WheatCNVbscan.sh SRR10766585 CNVbtmp CNVbout SRR10766585
```
