#!/bin/bash

REPO_NAME=$1
BASE_PATH="/home/ruiliu/Development"
PROJ_NAME="crustydb"
E2E_PERF_CMD="cargo bench -p e2e-benchmarks"
OUTPUT_FILE="e2e-results.txt"

JOIN_LEFT_BASELINE=200

echo "launch end-to-end benchmark for" $REPO_NAME

#cd $BASE_PATH$REPO_NAME/$PROJ_NAME
cd $BASE_PATH/$PROJ_NAME

#$E2E_PERF_CMD > $OUTPUT_FILE

while read line
do  
    if [[ $line == join_left* ]]; then
        res=${line#*'['}
        res_array=(${res//ms/ })
        join_left_median=${res_array[1]}
        
        if [ `echo "$join_left_median < $JOIN_LEFT_BASELINE"|bc` -eq 1 ]
        then
            # join_left_progress=($join_left_median - $JOIN_LEFT_BASELINE) / $JOIN_LEFT_BASELINE
            join_left_progress=$(echo "$join_left_median $JOIN_LEFT_BASELINE" | awk '{printf("%0.2f\n",($2-$1)/$2*100)}')
            echo "faster than the baseline around" $join_left_progress"%".
        else
            #join_left_progress=($JOIN_LEFT_BASELINE - $join_left_median) / $JOIN_LEFT_BASELINE
            join_left_progress=$(echo "$join_left_median $JOIN_LEFT_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "slower than the baseline around" $join_left_progress"%".
        fi
    fi
done < $OUTPUT_FILE