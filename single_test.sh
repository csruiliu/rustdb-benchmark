#!/bin/bash

# get parameters
REPO_DIR=$1
TEAM_CODE=$2

echo "Start to run e2e-benchmark for" $REPO_DIR

echo "End-to-End Performance Benchmark for TEAM" $TEAM_CODE > ${BASE_PATH}/${RESULTS_PATH}/$RESULT_FILE

# read path information and baseline from the configuration file
BASE_PATH=`sed '/^BASE_PATH=/!d;s/.*=//' config.ini`
PROJECTS_PATH=`sed '/^PROJECTS_PATH=/!d;s/.*=//' config.ini`
REPOS_FILE=`sed '/^REPOS_FILE=/!d;s/.*=//' config.ini`

JOIN_TINY_BASELINE=`sed '/^JOIN_TINY_BASELINE=/!d;s/.*=//' config.ini`
JOIN_SMALL_BASELINE=`sed '/^JOIN_SMALL_BASELINE=/!d;s/.*=//' config.ini`
JOIN_LARGE_BASELINE=`sed '/^JOIN_LARGE_BASELINE=/!d;s/.*=//' config.ini`
JOIN_LEFT_BASELINE=`sed '/^JOIN_LEFT_BASELINE=/!d;s/.*=//' config.ini`
JOIN_RIGHT_BASELINE=`sed '/^JOIN_RIGHT_BASELINE=/!d;s/.*=//' config.ini`

# cmd that triggers the e2e-benchmark 
E2E_PERF_CMD="cargo bench -p e2e-benchmarks"

# project name under each repo
RUSTDB_NAME="crustydb"

# e2e banchmark output for each repo
OUTPUT_FILE=$REPO_DIR"-e2e-output.txt"

# presentation result of e2e benchmark output for each repo  
RESULT_FILE=$REPO_DIR"-e2e-result.txt"

cd ${BASE_PATH}/${PROJECTS_PATH}/$REPO_DIR/${RUSTDB_NAME}

# launch e2e benchmark
$E2E_PERF_CMD > ${BASE_PATH}/${RESULTS_PATH}/$OUTPUT_FILE
RET=$?
if [ ${RET} -eq 0 ]
then
    echo "Finsih e2e benchmark."
else
    echo "Fail to launch e2e benchmark" > ${BASE_PATH}/${RESULTS_PATH}/$RESULT_FILE
    exit 0
fi

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
            echo "[JOIN TINY TEST] Your crustydb is faster than the baseline" $join_tiny_progress"%". > ${BASE_PATH}/${RESULTS_PATH}/$RESULT_FILE
        else
            join_tiny_progress=$(echo "$join_tiny_median $JOIN_TINY_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "[JOIN TINY TEST] Your crustydb is slower than the baseline" $join_tiny_progress"%". > ${BASE_PATH}/${RESULTS_PATH}/$RESULT_FILE
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
            echo "[JOIN SMALL TEST] Your crustydb is faster than the baseline" $join_small_progress"%". > ${BASE_PATH}/${RESULTS_PATH}/$RESULT_FILE
        else
            join_small_progress=$(echo "$join_small_median $JOIN_SMALL_BASELINE" | awk '{printf("%0.2f\n",($1-$2)/$2*100)}')
            echo "[JOIN SMALL TEST] Your crustydb is slower than the baseline" $join_small_progress"%". > ${BASE_PATH}/${RESULTS_PATH}/$RESULT_FILE
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

done < ${BASE_PATH}/${RESULTS_PATH}/$OUTPUT_FILE