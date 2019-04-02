#!/bin/bash

set -e

BUILD_ROOT="/tmp/build"
OUTPUT_ROOT="/mnt"

VERSION=$(git log --pretty=format:'Date: %cd, Revision: %h' | head -1)

rm -rf ${BUILD_ROOT:?} || :
mkdir -p ${BUILD_ROOT:?} || :

mkdocs build --clean -d ${BUILD_ROOT:?}

INDEXES=$(ls ${BUILD_ROOT:?}/*/index.html | sort -n)

xvfb-run wkhtmltopdf \
    --window-status ready \
    --print-media-type \
    --enable-internal-links \
    --load-error-handling ignore \
    --disable-smart-shrinking \
    --header-left "[webpage]:${VERSION}" \
    --footer-right "[page]/[topage]" \
    toc \
    ${BUILD_ROOT:?}/index.html \
    ${INDEXES:?} \
    ${OUTPUT_ROOT:?}/draft.pdf

rm -f draft-html.zip || :
zip -9r ${OUTPUT_ROOT:?}/draft-html.zip ${BUILD_ROOT:?}
