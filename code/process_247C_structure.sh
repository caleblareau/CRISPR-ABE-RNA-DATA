#!/bin/bash
#BSUB -J 247C[1-23]
#BSUB -e /dev/null
#BSUB -o /dev/null
#BSUB -q normal

# Pull input values
inputlist="need_structure/247C-structure-needArray.txt"
input=$(cat $inputlist | awk -v ln=$LSB_JOBINDEX "NR==ln")

# parse out individual variables from the string
set -- $input
old=$1
new=$2

/data/aryee/caleb/deep/conda/envs/tf/bin/RNAfold --noPS "${old}" | awk 'NR%3==0 || NR%3==1  {print $1}' > ${new}
gzip ${old}
gzip ${new}

