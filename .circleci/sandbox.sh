#!/bin/bash
# This builds docs from current sceptre version and pushes it to the website with lies in separate repository
set -e
# show where we are on the machine
echo "we are in:" $(pwd)

CIRCLE_TAG=1
CIRCLE_SHA1=""
if [[ -n "${CIRCLE_TAG}" ]] && [[ -n "${CIRCLE_SHA1}" ]]; then
    echo "oboje"
else
    echo "jedno"
fi

# checkout current scetre +
# build the current docs
# checkout doc-repo
# move current docs to doc-repo
# update metadata.js
# commit and push to doc-repo