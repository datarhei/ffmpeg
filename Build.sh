#!/bin/bash

set -au

function source_env() {
  env=${1:-.env}
  [ ! -f "${env}" ] && { echo "Env file ${env} doesn't exist"; return 1; }
  eval $(sed -e '/^\s*$/d' -e '/^\s*#/d' -e 's/=/="/' -e 's/$/"/' -e 's/^/export /' "${env}")
}

function build_default_native() {
  source_env ./Build.alpine.env
  docker build \
    --progress=plain \
    --build-arg BUILD_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    -f Dockerfile.alpine \
    -t datarhei/base:ffmpeg${FFMPEG_VERSION}-${OS_NAME}${OS_VERSION} .
  docker tag datarhei/base:ffmpeg${FFMPEG_VERSION}-${OS_NAME}${OS_VERSION} datarhei/base:$OS_NAME-ffmpeg-$OS_VERSION-$FFMPEG_VERSION
}

function build_default() {
  source_env ./Build.alpine.env
  # "--load" does not support multiple platforms
  # use "--push" to publish
  # --platform linux/amd64,linux/arm64,linux/arm/v7
  docker buildx build \
    --load \
    --progress=plain \
    --build-arg BUILD_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    --platform linux/amd64 \
    -f Dockerfile.alpine \
    -t datarhei/base:ffmpeg${FFMPEG_VERSION}-${OS_NAME}${OS_VERSION} .
  docker tag datarhei/base:ffmpeg${FFMPEG_VERSION}-${OS_NAME}${OS_VERSION} datarhei/base:$OS_NAME-ffmpeg-$OS_VERSION-$FFMPEG_VERSION
  docker tag datarhei/base:ffmpeg${FFMPEG_VERSION}-${OS_NAME}${OS_VERSION} datarhei/base:$OS_NAME-ffmpeg-latest
}

function build_rpi() {
  source_env ./Build.alpine.env
  source_env ./Build.alpine.rpi.env
  docker build \
    --progress=plain \
    --build-arg BUILD_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    -f Dockerfile.alpine.rpi \
    -t datarhei/base:ffmpeg${FFMPEG_VERSION}-rpi-${OS_NAME}${OS_VERSION} .
  docker tag datarhei/base:ffmpeg${FFMPEG_VERSION}-rpi-${OS_NAME}${OS_VERSION} datarhei/base:$OS_NAME-ffmpeg-rpi-$OS_VERSION-$FFMPEG_VERSION
  docker tag datarhei/base:ffmpeg${FFMPEG_VERSION}-rpi-${OS_NAME}${OS_VERSION} datarhei/base:$OS_NAME-ffmpeg-rpi-latest
}

function build_cuda11() {
  source_env ./Build.ubuntu.cuda11.env
  docker build \
    --progress=plain \
    --build-arg BUILD_IMAGE=nvidia/cuda:$CUDA_VERSION-devel-ubuntu$OS_VERSION \
    --build-arg DEPLOY_IMAGE=nvidia/cuda:$CUDA_VERSION-runtime-ubuntu$OS_VERSION \
    --build-arg FFNVCODEC_VERSION=$FFNVCODEC_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    -f Dockerfile.ubuntu.cuda11 \
    -t datarhei/base:ffmpeg${FFMPEG_VERSION}-cuda-ubuntu$OS_VERSION-cuda${CUDA_VERSION} .
}

function build_cuda12() {
  source_env ./Build.ubuntu.cuda12.env
  docker build \
    --progress=plain \
    --build-arg BUILD_IMAGE=nvidia/cuda:$CUDA_VERSION-devel-ubuntu$OS_VERSION \
    --build-arg DEPLOY_IMAGE=nvidia/cuda:$CUDA_VERSION-runtime-ubuntu$OS_VERSION \
    --build-arg FFNVCODEC_VERSION=$FFNVCODEC_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    -f Dockerfile.ubuntu.cuda12 \
    -t datarhei/base:ffmpeg${FFMPEG_VERSION}-cuda-ubuntu$OS_VERSION-cuda${CUDA_VERSION} .
}

function build_vaapi() {
  source_env ./Build.ubuntu.env
  source_env ./Build.ubuntu.vaapi.env
  docker buildx build \
    --load \
    --progress=plain \
    --build-arg BUILD_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg DEPLOY_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    --platform linux/amd64 \
    -f Dockerfile.ubuntu.vaapi \
    -t datarhei/base:ffmpeg${FFMPEG_VERSION}-vaapi-${OS_NAME}${OS_VERSION} .
}

main() {
  if [[ $# == 0 ]]; then
    echo "Options available: default, default_native, rpi, cuda11, cuda12, vaapi"
    exit 0
  else
    if [[ $1 == "default" ]]; then
      build_default
    elif [[ $1 == "default_native" ]]; then
      build_default_native
    elif [[ $1 == "rpi" ]]; then
      build_rpi
    elif [[ $1 == "cuda11" ]]; then
      build_cuda11
    elif [[ $1 == "cuda12" ]]; then
      build_cuda12
    elif [[ $1 == "vaapi" ]]; then
      build_vaapi
    fi
  fi
}

main $@

exit 0
