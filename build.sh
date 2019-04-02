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
    /tmp/draft.pdf

cp -a /tmp/draft.pdf ${OUTPUT_ROOT:?}/. || :

rm -f /tmp/draft-html.zip || :
zip -9r /tmp/draft-html.zip ${BUILD_ROOT:?}
cp -a /tmp/draft-html.zip ${OUTPUT_ROOT:?}/. || :
