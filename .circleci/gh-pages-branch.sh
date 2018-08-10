#!/bin/bash
set -e
# show where we are on the machine
pwd

# check env vars
declare -a vars=(GIT_HOST PAGES_BRANCH DOCS_DIR GITHUB_EMAIL GITHUB_TOKEN CIRCLE_USERNAME CIRCLE_REPOSITORY_URL CIRCLE_USERNAME CIRCLE_BUILD_NUM)
for var_name in "${vars[@]}"
do
    [[ -z "$(eval "echo \$${var_name}")" ]] && { echo "Variable ${var_name} is not set or empty"; exit 1; }
done

GITHUB_NAME=${CIRCLE_USERNAME}

mkdir -p ${DOCS_DIR}

# build docs in docs dir
sphinx-build docs/_source ${DOCS_DIR} -b html -A GHPAGES=True


#### go to docs dir, setup git and upload the results ####
cd ${DOCS_DIR}


######## create correct origin url ########
# strip everything to github.com
REPO_PATH=${CIRCLE_REPOSITORY_URL#*${GIT_HOST}}
# remove : or / at the beginning
REPO_PATH=${REPO_PATH:1}


GH_PAGES_URL="https://${CIRCLE_USERNAME}:${GITHUB_TOKEN}@${GIT_HOST}/${REPO_PATH}"
########

git config --global user.email "${GITHUB_EMAIL}" > /dev/null 2>&1
git config --global user.name "${GITHUB_NAME}" > /dev/null 2>&1

git init
git remote add --tags origin ${GH_PAGES_URL}

# switch into the the gh-pages branch
if git rev-parse --verify origin/${PAGES_BRANCH} > /dev/null 2>&1
then
    git checkout ${PAGES_BRANCH}
    # delete any old site as we are going to replace it
    # Note: this explodes if there aren't any, so moving it here for now
    git rm -rf .
else
    git checkout --orphan ${PAGES_BRANCH}
fi

git add -A
git commit --allow-empty -m "Deploy to GitHub pages ${CIRCLE_BUILD_NUM} [ci skip]"
git push --force --quiet origin ${PAGES_BRANCH}

echo "Finished Deployment!"
