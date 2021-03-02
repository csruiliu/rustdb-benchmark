#!/bin/bash

# read path information and baseline from the configuration file
BASE_PATH=$HOME
GIT_PATH=`sed '/^GIT_PATH=/!d;s/.*=//' config.ini`
PROJECTS_PATH=`sed '/^PROJECTS_PATH=/!d;s/.*=//' config.ini`
REPOS_FILE=`sed '/^REPOS_FILE=/!d;s/.*=//' config.ini`
RESULTS_PATH=`sed '/^RESULTS_PATH=/!d;s/.*=//' config.ini`

# JOIN_TINY_BASELINE=`sed '/^JOIN_TINY_BASELINE=/!d;s/.*=//' config.ini`
# JOIN_SMALL_BASELINE=`sed '/^JOIN_SMALL_BASELINE=/!d;s/.*=//' config.ini`
# JOIN_LARGE_BASELINE=`sed '/^JOIN_LARGE_BASELINE=/!d;s/.*=//' config.ini`
# JOIN_LEFT_BASELINE=`sed '/^JOIN_LEFT_BASELINE=/!d;s/.*=//' config.ini`
# JOIN_RIGHT_BASELINE=`sed '/^JOIN_RIGHT_BASELINE=/!d;s/.*=//' config.ini`

# cmd that triggers the e2e-benchmark 
E2E_PERF_CMD="cargo bench -p e2e-benchmarks"

# project name under each repo
RUSTDB_NAME="crustydb"

# presentation result of e2e benchmark output for current repo  
RESULT_FILE="e2e-result.txt"

RESULT_PATH=${BASE_PATH}/${RESULTS_PATH}/$RESULT_FILE

if [ -f ${RESULT_PATH} ]
then
    echo "result file exists, clean it"
    rm ${RESULT_PATH}
fi

# create folder for all repos' results
if [ -d "${BASE_PATH}/${RESULTS_PATH}" ]
then
    rm -rf "${BASE_PATH}/${RESULTS_PATH}"
fi

mkdir "${BASE_PATH}/${RESULTS_PATH}"
RET=$?
if [ ${RET} -eq 0 ]
then
    echo "Create folder for all repos results successfully."
else
    echo "Fail to create the folder for all repos results."
    exit 0
fi

# iterate all repos in the repos.txt (REPOS_FILE)
while read line
do  
    CUR_REPO=${line%%:*}
    CUR_TEAMCODE=${line#*:}

    # e2e banchmark output for current repo
    REPO_OUTPUT_FILE=${CUR_REPO}"-e2e-output.txt"

    if [ -d "${BASE_PATH}/${PROJECTS_PATH}/${CUR_REPO}" ]
    then
        echo "team" ${CUR_REPO} "project exists, clean it"  
        rm -rf ${BASE_PATH}/${PROJECTS_PATH}/${CUR_REPO}
    fi

    echo "fetch the project for team ${CUR_REPO}"
    git clone ${GIT_PATH}/${CUR_REPO}.git ${BASE_PATH}/${PROJECTS_PATH}/${CUR_REPO}    

    # start to launch e2e-benchmark for current repo
    echo "Start to run e2e-benchmark for" ${CUR_REPO}

    # input team code for current repo
    echo "### End-to-End Performance Benchmark for TEAM ${CUR_TEAMCODE} ###" >> ${RESULT_PATH}

    cd ${BASE_PATH}/${PROJECTS_PATH}/${CUR_REPO}
    
    COMMIT_SHA=`git rev-parse HEAD | cut -c 1-7`
    echo "COMMIT: ${COMMIT_SHA}" >> ${RESULT_PATH}

    cd ./${RUSTDB_NAME}

    # launch e2e benchmark
    $E2E_PERF_CMD > ${BASE_PATH}/${RESULTS_PATH}/$REPO_OUTPUT_FILE
    RET=$?
    if [ ${RET} -eq 0 ]
    then
        echo "Finsih e2e benchmark."
    else
        echo "Fail to launch e2e benchmark"
        echo "[JOIN TINY TEST] Failed" >> ${RESULT_PATH}
        echo "[JOIN SMALL TEST] Failed" >> ${RESULT_PATH}
        echo "[JOIN LARGE TEST] Failed" >> ${RESULT_PATH}
        echo "[JOIN LEFT TEST] Failed" >> ${RESULT_PATH}
        echo "[JOIN RIGHT TEST] Failed" >> ${RESULT_PATH}
        continue
    fi

    # analyze the output to generate result 
    while read line
    do  
        if [[ $line == join_tiny* ]]; then
            echo $line
            strip_line=${line#*:}
            res_array=(${strip_line//[[\]]/})        
            join_tiny_median=${res_array[2]}
            join_tiny_unit=${res_array[3]}

            echo "TINY TEST: "${join_tiny_median}
            echo "[JOIN TINY TEST] Your crustydb runs" ${join_tiny_median} ${join_tiny_unit}. >> ${RESULT_PATH}
        fi

        if [[ $line == join_small* ]]; then
            echo $line
            strip_line=${line#*:}
            res_array=(${strip_line//[[\]]/})    
            join_small_median=${res_array[2]}
            join_small_unit=${res_array[3]}
            echo "SMALL TEST: "$join_small_median
            echo "[JOIN SMALL TEST] Your crustydb runs" ${join_small_median} ${join_small_unit}. >> ${RESULT_PATH}
        fi

        if [[ $line == join_large* ]]; then
            echo $line
            strip_line=${line#*:}
            res_array=(${strip_line//[[\]]/})    
            join_large_median=${res_array[2]}
            join_large_unit=${res_array[3]}
            echo "LARGE TEST: "$join_large_median
            echo "[JOIN LARGE TEST] Your crustydb runs" ${join_large_median} ${join_large_unit}. >> ${RESULT_PATH}
        fi

        if [[ $line == join_left* ]]; then
            echo $line
            strip_line=${line#*:}
            res_array=(${strip_line//[[\]]/})    
            join_left_median=${res_array[2]}
            join_left_unit=${res_array[3]}
            echo "LEFT TEST: "$join_left_median
            echo "[JOIN LEFT TEST] Your crustydb runs" ${join_left_median} ${join_left_unit}. >> ${RESULT_PATH}
        fi

        if [[ $line == join_right* ]]; then
            echo $line
            strip_line=${line#*:}
            res_array=(${strip_line//[[\]]/})    
            join_right_median=${res_array[2]}
            join_right_unit=${res_array[3]}
            echo "RIGHT TEST: "$join_right_median
            echo "[JOIN RIGHT TEST] Your crustydb runs" ${join_right_median} ${join_right_unit}. >> ${RESULT_PATH}
        fi

    done < ${BASE_PATH}/${RESULTS_PATH}/$REPO_OUTPUT_FILE

done < ${BASE_PATH}/${REPOS_FILE}
