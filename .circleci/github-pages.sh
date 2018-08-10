#!/bin/bash
# This builds docs from current sceptre version and pushes it to the website with lies in separate repository
set -ex
# show where we are on the machine
echo "we are in:" $(pwd)
ls -laF
# check env vars
#declare -a vars=(DOCS_DIR GITHUB_EMAIL GITHUB_TOKEN CIRCLE_USERNAME CIRCLE_REPOSITORY_URL CIRCLE_USERNAME CIRCLE_BUILD_NUM)
#for var_name in "${vars[@]}"
#do
#    [[ -z "$(eval "echo \$${var_name}")" ]] && { echo "Variable ${var_name} is not set or empty"; exit 1; }
#done
CODE_DIR=$(pwd)
GITHUB_NAME=${CIRCLE_USERNAME}

mkdir -p ${DOCS_DIR}

#### go to docs dir, setup git and upload the results ####
cd ${DOCS_DIR}


######## create correct origin url ########
# strip everything to github.com
WEBSITE_REPO="https://github.com/cicd-organisation/project-docs.git"
WEBSITE_DIR=$(basename ${WEBSITE_REPO%.*})

# in docs === html/, doctrees/

# clone web site
git clone ${WEBSITE_REPO}

# ensure sceptre-docs exist in website
BUILD_DIR=${DOCS_DIR}/${WEBSITE_DIR}/docs

mkdir -p ${BUILD_DIR}

VERSION="dev"

if [[ -n "${CIRCLE_TAG}" ]]; then
    # deploy tagged
    echo "oboje"
    echo ${CIRCLE_TAG}
    VERSION="CIRCLE_TAG"

fi

VERSION_BUILD_DIR=${BUILD_DIR}/${VERSION}

echo "Building docs in" ${VERSION_BUILD_DIR}

# remove version directory if exists
rm -rf ${VERSION_BUILD_DIR}

# build docs in correct dir dir
sphinx-build ${CODE_DIR}/docs/_source ${VERSION_BUILD_DIR} -q -d /tmp -b html -A GHPAGES=True -a version=${VERSION}

find .
# get current sceptre version
#CURRENT_VERSION=$(python -c "import sceptre; print(sceptre.__version__)")
#
#
#git config --global user.email "${GITHUB_EMAIL}" > /dev/null 2>&1
#git config --global user.name "${GITHUB_NAME}" > /dev/null 2>&1
#
#
## switch into the the gh-pages branch
#if git rev-parse --verify origin/${PAGES_BRANCH} > /dev/null 2>&1
#then
#    git checkout ${PAGES_BRANCH}
#    # delete any old site as we are going to replace it
#    # Note: this explodes if there aren't any, so moving it here for now
#    git rm -rf .
#else
#    git checkout --orphan ${PAGES_BRANCH}
#fi
#
#git add -A
#git commit --allow-empty -m "Deploy to GitHub pages ${CIRCLE_BUILD_NUM} [ci skip]"
#git push --force --quiet origin ${PAGES_BRANCH}

echo "Finished Deployment!"


# checkout current scetre +
# build the current docs
# checkout doc-repo
# move current docs to doc-repo
# update metadata.js
# commit and push to doc-repo