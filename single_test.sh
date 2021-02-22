#!/bin/bash

REPO_NAME=$1
BASE_PATH="/home/ruiliu/Development"
PROJ_NAME="crustydb"
E2E_PERF_CMD="cargo bench -p e2e-benchmarks"
OUTPUT_FILE="e2e-results.txt"

JOIN_TINY_BASELINE=200
JOIN_SMALL_BASELINE=200
JOIN_LARGE_BASELINE=200
JOIN_LEFT_BASELINE=200
JOIN_RIGHT_BASELINE=200

echo "Launching end-to-end benchmark" $REPO_NAME

#cd $BASE_PATH$REPO_NAME/$PROJ_NAME
cd $BASE_PATH/$PROJ_NAME

#$E2E_PERF_CMD > $OUTPUT_FILE

while read line
do  
    if [[ $line == join_tiny* ]]; then
        echo $line
        res_array=(${line//[a-zA-Z:_[\]]/})        
        join_tiny_median=${res_array[1]}
        echo "TINY TEST: "$join_tiny_median
        
        if [ `echo "$join_tiny_median < $JOIN_TINY_BASELINE"|bc` -eq 1 ]
        then
            join_tiny_progress=$(echo "$join_tiny_median $JOIN_TINY_BASELINE" | awk '{printf("%0.2f\n",($2-$1)/$2*100)}')
            echo "[JOIN TINY TEST] Your crustydb is faster than the baseline" $join_tiny_progress"%".
        else
            join_tiny_progress=$(echo "$join_tiny_median $JOIN_TINY_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "[JOIN TINY TEST] Your crustydb is slower than the baseline" $join_tiny_progress"%".
        fi
    fi

    if [[ $line == join_small* ]]; then
        echo $line
        res_array=(${line//[a-zA-Z:_[\]]/})    
        join_small_median=${res_array[1]}
        echo "SMALL TEST: "$join_small_median

        if [ `echo "$join_small_median < $JOIN_SMALL_BASELINE"|bc` -eq 1 ]
        then
            join_small_progress=$(echo "$join_small_median $JOIN_SMALL_BASELINE" | awk '{printf("%0.2f\n",($2-$1)/$2*100)}')
            echo "[JOIN SMALL TEST] Your crustydb is faster than the baseline" $join_small_progress"%".
        else
            join_small_progress=$(echo "$join_small_median $JOIN_SMALL_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "[JOIN SMALL TEST] Your crustydb is slower than the baseline" $join_small_progress"%".
        fi
    fi

    if [[ $line == join_large* ]]; then
        echo $line
        res_array=(${line//[a-zA-Z:_[\]]/})    
        join_large_median=${res_array[1]}
        echo "LARGE TEST: "$join_large_median

        if [ `echo "$join_large_median < $JOIN_LARGE_BASELINE"|bc` -eq 1 ]
        then
            join_large_progress=$(echo "$join_large_median $JOIN_LARGE_BASELINE" | awk '{printf("%0.2f\n",($2-$1)/$2*100)}')
            echo "[JOIN LARGE TEST] Your crustydb is faster than the baseline" $join_large_progress"%".
        else
            join_large_progress=$(echo "$join_large_median $JOIN_LARGE_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "[JOIN LARGE TEST] Your crustydb is slower than the baseline" $join_large_progress"%".
        fi
    fi

    if [[ $line == join_left* ]]; then
        echo $line
        res_array=(${line//[a-zA-Z:_[\]]/})    
        join_left_median=${res_array[1]}
        echo "LEFT TEST: "$join_left_median

        if [ `echo "$join_left_median < $JOIN_LEFT_BASELINE"|bc` -eq 1 ]
        then
            join_left_progress=$(echo "$join_left_median $JOIN_LEFT_BASELINE" | awk '{printf("%0.2f\n",($2-$1)/$2*100)}')
            echo "[JOIN LEFT TEST] Your crustydb is faster than the baseline" $join_left_progress"%".
        else
            join_left_progress=$(echo "$join_left_median $JOIN_LEFT_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "[JOIN LEFT TEST] Your crustydb is slower than the baseline" $join_left_progress"%".
        fi
    fi

    if [[ $line == join_right* ]]; then
        echo $line
        res_array=(${line//[a-zA-Z:_[\]]/})    
        join_right_median=${res_array[1]}
        echo "RIGHT TEST: "$join_right_median

        if [ `echo "$join_right_median < $JOIN_RIGHT_BASELINE"|bc` -eq 1 ]
        then
            join_right_progress=$(echo "$join_right_median $JOIN_RIGHT_BASELINE" | awk '{printf("%0.2f\n",($2-$1)/$2*100)}')
            echo "[JOIN RIGHT TEST] Your crustydb is faster than the baseline" $join_right_progress"%".
        else
            join_right_progress=$(echo "$join_right_median $JOIN_RIGHT_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "[JOIN RIGHT TEST] Your crustydb is slower than the baseline" $join_right_progress"%".
        fi
    fi

done < $OUTPUT_FILE