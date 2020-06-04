BASE_GOOGLE_URL="https://storage.googleapis.com/"

CICD_FOLDER='dotcicd'
LIB_FOLDER=${CICD_FOLDER}/library
source ${LIB_FOLDER}/pipeline/common.sh

resolveCurrentBranch

if [[ "${TEST_TYPE}" == "unit" ]]; then
  GOOGLE_STORAGE_JOB_COMMIT_FOLDER="cicd-246518-tests/${TRAVIS_COMMIT_SHORT}/unit"
  GOOGLE_STORAGE_JOB_BRANCH_FOLDER="cicd-246518-tests/${CURRENT_BRANCH}/unit"
elif [[ "${TEST_TYPE}" == "curl" ]]; then
  GOOGLE_STORAGE_JOB_COMMIT_FOLDER="cicd-246518-tests/${TRAVIS_COMMIT_SHORT}/curl/${DB_TYPE}"
  GOOGLE_STORAGE_JOB_BRANCH_FOLDER="cicd-246518-tests/${CURRENT_BRANCH}/curl/${DB_TYPE}"
elif [[ "${TEST_TYPE}" == "integration" ]]; then
  GOOGLE_STORAGE_JOB_COMMIT_FOLDER="cicd-246518-tests/${TRAVIS_COMMIT_SHORT}/integration/${DB_TYPE}"
  GOOGLE_STORAGE_JOB_BRANCH_FOLDER="cicd-246518-tests/${CURRENT_BRANCH}/integration/${DB_TYPE}"
fi

reportsCommitIndexURL="${BASE_GOOGLE_URL}${GOOGLE_STORAGE_JOB_COMMIT_FOLDER}/reports/html/index.html"
reportsBranchIndexURL="${BASE_GOOGLE_URL}${GOOGLE_STORAGE_JOB_BRANCH_FOLDER}/reports/html/index.html"
logCommitURL="${BASE_GOOGLE_URL}${GOOGLE_STORAGE_JOB_COMMIT_FOLDER}/logs/dotcms.log"
logBranchURL="${BASE_GOOGLE_URL}${GOOGLE_STORAGE_JOB_BRANCH_FOLDER}/logs/dotcms.log"

echo ""
echo -e "\e[36m==========================================================================================================================\e[0m"
echo -e "\e[36m==========================================================================================================================\e[0m"
echo -e "\e[1;36m                                                REPORTING\e[0m"
echo
echo -e "\e[31m   ${reportsBranchIndexURL}\e[0m"
if [[ "${TEST_TYPE}" != "curl" ]]; then
  echo -e "\e[31m   ${logBranchURL}\e[0m"
fi
echo
echo -e "\e[31m   ${reportsCommitIndexURL}\e[0m"
if [[ "${TEST_TYPE}" != "curl" ]]; then
  echo -e "\e[31m   ${logCommitURL}\e[0m"
fi
echo
if [ "$TRAVIS_PULL_REQUEST" != "false" ];
then
  echo "   GITHUB pull request: [https://github.com/dotCMS/core/pull/${TRAVIS_PULL_REQUEST}]"
  echo
fi
echo -e "\e[36m==========================================================================================================================\e[0m"
echo -e "\e[36m==========================================================================================================================\e[0m"
echo ""