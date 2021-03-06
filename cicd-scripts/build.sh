#!/bin/bash
# Copyright (c) 2020 Red Hat, Inc.
# Copyright Contributors to the Open Cluster Management project

cd $(dirname $0)

#if on PR not main or release, update PR with latest charts.Otherwise just build image
if [ "${TRAVIS_BRANCH}" != "main" ] && [[ "${TRAVIS_BRANCH}" != "release-"* ]] && [[ "${TRAVIS_BRANCH}" != "dev-"* ]]; then
    git clone git@github.com:open-cluster-management/multicloudhub-repo.git
    cd multicloudhub-repo
    git checkout "${TRAVIS_BRANCH}"
    cicd-scripts/chart-sync.sh
    docker build -t $1 .
    git add .
    git commit -m "[skip ci] add charts"
    git merge main -m "[skip ci] resolve conflicts" -s recursive -X ours
    git push origin "HEAD:${TRAVIS_BRANCH}"
else 
    cd ..
    docker build -t $1 .
fi
    
