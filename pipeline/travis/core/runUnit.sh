#!/bin/bash

export TEST_TYPE=unit

DOCKER_SOURCE=${DOT_CICD_LIB}/docker

setupTestRun unit

bell &
gcloud builds submit \
  --config=${DOT_CICD_LIB}/pipeline/travis/core/cloudrun-unit.yaml \
  --substitutions=_CUSTOM_RUN_ID=$TRAVIS_COMMIT_SHORT,_PULL_REQUEST=$TRAVIS_PULL_REQUEST,_GOOGLE_CREDENTIALS_BASE64=$GOOGLE_CREDENTIALS_BASE64,_GITHUB_USER=$GITHUB_USER,_GITHUB_USER_TOKEN=$GITHUB_USER_TOKEN,_DOCKER_SOURCE=$DOCKER_SOURCE,_DOT_CICD_PERSIST=$DOT_CICD_PERSIST .
exit $?

dcResult=$?

cleanUpTest unit

if [[ ${dcResult} == 0 ]]; then
  exit 0
else
  exit 1
fi
