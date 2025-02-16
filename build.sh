#!/bin/bash
set -x

# Accepted values for ARCH are amd64, armhf, arm64, i386
ARCH=${1:-amd64}
VERSION=${2:-0.1.1}
OPTS=${3}
TAG=${VERSION}_${ARCH}

case ${ARCH} in
    "amd64")  IMAGE_ARCH="$BASE" ;;
    "armhf")  IMAGE_ARCH="arm32v7/$BASE" ;;
    "arm64")  IMAGE_ARCH="arm64v8/$BASE" ;;
    "i386")   IMAGE_ARCH="i386/$BASE" ;;
    *) echo "unrecognized architecture '$ARCH'" >>/dev/stderr ; exit 1 ;;
esac



docker build \
          --build-arg ARCH=${ARCH} \
          --build-arg VERSION=${VERSION} \
          --build-arg IMAGE_ARCH=${IMAGE_ARCH} \
          -t hs5:${TAG} \
          .