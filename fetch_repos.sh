#!/bin/bash

# read path information from the configuration file
BASE_PATH=`sed '/^BASE_PATH=/!d;s/.*=//' config.ini`
GIT_PATH=`sed '/^GIT_PATH=/!d;s/.*=//' config.ini`
PROJECT_PATH=`sed '/^PROJECT_PATH=/!d;s/.*=//' config.ini`

REPOS_FILE=`sed '/^REPOS_FILE=/!d;s/.*=//' config.ini`

echo $BASE_PATH
echo $GIT_PATH
echo $PROJECT_PATH
echo $REPOS_FILE

cd ${BASE_PATH}/${PROJECT_PATH}

while read line
do  
    CUR_REPO=${line%%:*}
    
    if [ -d "${BASE_PATH}/${PROJECT_PATH}/${CUR_REPO}" ]
    then
        echo "team" ${CUR_REPO} "project exists, clean it"  
        rm -rf ${BASE_PATH}/${PROJECT_PATH}/${CUR_REPO}
    fi

    echo "fetch the project for team ${CUR_REPO}"
    git clone ${GIT_PATH}/${CUR_REPO}.git
    
done < ${BASE_PATH}/${REPOS_FILE}