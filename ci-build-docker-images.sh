#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT=$SCRIPT_DIR

log() { echo "$1" >&2; }

TAG="${TAG:?TAG env variable must be specified}"
REPO_PREFIX="${REPO_PREFIX:?REPO_PREFIX env variable must be specified}"

# build image
svcname="frontend"
image="${REPO_PREFIX}/$svcname:$TAG"
cd "src/$svcname"

log "Building (and pushing) image on GitLab registry: ${image}"
buildah images
buildah build \
    --build-arg TARGETOS=linux \
    --build-arg TARGETARCH=amd64 \
    --build-arg SKAFFOLD_GO_GCFLAGS="" \
    -t $image
buildah images
buildah push --tls-verify=false $image

log "Successfully built and pushed all images."
