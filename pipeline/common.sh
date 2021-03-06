#!/bin/bash

# Git clone by providing repo, destination folder and branch to check out
function gitClone {
  local repo=$1
  local dest=$2
  local branch=$3

  echo "Cloning repo from ${repo}"
  git clone ${repo} ${dest}

  if [[ $? != 0 ]]; then
    echo "Error cloning repo '${repo}'"
    exit 1
  fi

  if [[ ! -z "${branch}" ]]; then
    echo "Checking out branch ${DOT_CICD_BRANCH}"
    git checkout -b ${DOT_CICD_BRANCH}
    if [[ $? != 0 ]]; then
      echo "Error checking out branch '${branch}', continuing with master"
    fi
  fi
}

# Fetch CI/CD github repo to consume its library
function gitFetchRepo {
  local repo=$1
  local dest=$2
  local branch=$3

  if [[ -z "${repo}" ]]; then
    echo "Repo not provided, cannot continue"
    exit 1
  fi

  if [[ -z "${dest}" ]]; then
    dest=cicd/
  fi

  gitClone $@
}

# Cleans up setup for Docker test resources
function cleanUpTest {
  local testType=${1}

  if [[ ! -d ${DOCKER_SOURCE}/tests/${testType}/setup ]]; then
    echo "Test type location ${DOCKER_SOURCE}/tests/${testType}/setup does not exist, aborting clean up"
    exit 1
  fi

  rm -rf ${DOCKER_SOURCE}/tests/${testType}/setup
}

# Prepares resources to build integration image
function setupBuildBaseTests {
  mkdir ${DOCKER_SOURCE}/tests/integration/setup
  cp -R ${DOCKER_SOURCE}/setup/build-src ${DOCKER_SOURCE}/tests/integration/setup
  cp -R ${DOCKER_SOURCE}/setup/ROOT ${DOCKER_SOURCE}/tests/integration/setup
}

# Prepares resources to run unit tests
function setupTestRun {
  local testType=${1}

  if [[ -d ${DOCKER_SOURCE}/tests/${testType}/setup ]]; then
    rm -rf ${DOCKER_SOURCE}/tests/${testType}/setup
  fi

  mkdir ${DOCKER_SOURCE}/tests/${testType}/setup
  cp -R ${DOCKER_SOURCE}/setup/db ${DOCKER_SOURCE}/tests/${testType}/setup
}
