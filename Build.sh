#!/bin/bash

set -au

function source_env() {
  env=${1:-.env}
  [ ! -f "${env}" ] && { echo "Env file ${env} doesn't exist"; return 1; }
  eval $(sed -e '/^\s*$/d' -e '/^\s*#/d' -e 's/=/="/' -e 's/$/"/' -e 's/^/export /' "${env}")
}

function build_default() {
  source_env ./Build.alpine.env
  # "--load" does not support multiple platforms
  # use "--push" to publish
  # --platform linux/amd64,linux/arm64,linux/arm/v7
  docker buildx build \
    --load \
    --build-arg BUILD_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg FREETYPE_VERSION=$FREETYPE_VERSION \
    --build-arg XML2_VERSION=$XML2_VERSION \
    --build-arg SRT_VERSION=$SRT_VERSION \
    --build-arg X264_VERSION=$X264_VERSION \
    --build-arg X265_VERSION=$X265_VERSION \
    --build-arg VPX_VERSION=$VPX_VERSION \
    --build-arg LAME_VERSION=$LAME_VERSION \
    --build-arg OPUS_VERSION=$OPUS_VERSION \
    --build-arg VORBIS_VERSION=$VORBIS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    --platform linux/amd64 \
    -f Dockerfile.alpine \
    -t datarhei/base:$OS_NAME-ffmpeg-$OS_VERSION-$FFMPEG_VERSION .
}

function build_rpi() {
  source_env ./Build.alpine.env
  source_env ./Build.alpine.rpi.env
  # "--load" does not support multiple platforms
  # use "--push" to publish
  # --platform linux/arm64,linux/arm/v7
  docker buildx build \
    --load \
    --build-arg BUILD_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg FREETYPE_VERSION=$FREETYPE_VERSION \
    --build-arg XML2_VERSION=$XML2_VERSION \
    --build-arg SRT_VERSION=$SRT_VERSION \
    --build-arg X264_VERSION=$X264_VERSION \
    --build-arg X265_VERSION=$X265_VERSION \
    --build-arg VPX_VERSION=$VPX_VERSION \
    --build-arg LAME_VERSION=$LAME_VERSION \
    --build-arg OPUS_VERSION=$OPUS_VERSION \
    --build-arg VORBIS_VERSION=$VORBIS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    --build-arg RPI_VERSION=$RPI_VERSION \
    --build-arg ALSA_VERSION=$ALSA_VERSION \
    --platform linux/arm64 \
    -f Dockerfile.alpine.rpi \
    -t datarhei/base:$OS_NAME-ffmpeg-rpi-$OS_VERSION-$FFMPEG_VERSION .
}

function build_cuda() {
  source_env ./Build.ubuntu.env
  source_env ./Build.ubuntu.cuda.env
  docker buildx build \
    --load \
    --build-arg BUILD_IMAGE=nvidia/cuda:$CUDA_VERSION-devel-$OS_NAME$OS_VERSION \
    --build-arg DEPLOY_IMAGE=nvidia/cuda:$CUDA_VERSION-runtime-$OS_NAME$OS_VERSION \
    --build-arg FFNVCODEC_VERSION=$FFNVCODEC_VERSION \
    --build-arg FREETYPE_VERSION=$FREETYPE_VERSION \
    --build-arg XML2_VERSION=$XML2_VERSION \
    --build-arg SRT_VERSION=$SRT_VERSION \
    --build-arg X264_VERSION=$X264_VERSION \
    --build-arg X265_VERSION=$X265_VERSION \
    --build-arg VPX_VERSION=$VPX_VERSION \
    --build-arg LAME_VERSION=$LAME_VERSION \
    --build-arg OPUS_VERSION=$OPUS_VERSION \
    --build-arg VORBIS_VERSION=$VORBIS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    --platform linux/amd64 \
    -f Dockerfile.ubuntu.cuda \
    -t datarhei/base:$OS_NAME-ffmpeg-cuda-$OS_VERSION-$FFMPEG_VERSION-$CUDA_VERSION .
}

function build_vaapi() {
  source_env ./Build.alpine.env
  source_env ./Build.alpine.vaapi.env
  docker buildx build \
    --load \
    --build-arg BUILD_IMAGE=$OS_NAME:$OS_VERSION \
    --build-arg FREETYPE_VERSION=$FREETYPE_VERSION \
    --build-arg XML2_VERSION=$XML2_VERSION \
    --build-arg SRT_VERSION=$SRT_VERSION \
    --build-arg X264_VERSION=$X264_VERSION \
    --build-arg X265_VERSION=$X265_VERSION \
    --build-arg VPX_VERSION=$VPX_VERSION \
    --build-arg LAME_VERSION=$LAME_VERSION \
    --build-arg OPUS_VERSION=$OPUS_VERSION \
    --build-arg VORBIS_VERSION=$VORBIS_VERSION \
    --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
    --build-arg LIBAV_VERSION=$LIBAV_VERSION \
    --build-arg LIBVDPAU_VERSION=$LIBVDPAU_VERSION \
    --build-arg MESA_VA_GALLIUM_VERSION=$MESA_VA_GALLIUM_VERSION \
    --build-arg MESA_VDPAU_GALLIUM_VERSION=$MESA_VDPAU_GALLIUM_VERSION \
    --build-arg LIBVA_VDPAU_DRIVER_VERSION=$LIBVA_VDPAU_DRIVER_VERSION \
    --build-arg INTEL_GMMLIB_VERSION=$INTEL_GMMLIB_VERSION \
    --build-arg INTEL_MEDIA_DRIVER_VERSION=$INTEL_MEDIA_DRIVER_VERSION \
    --build-arg INTEL_MEDIA_SDK_VERSION=$INTEL_MEDIA_SDK_VERSION \
    --build-arg INTEL_VAAPI_DRIVER=$INTEL_VAAPI_DRIVER \
    --platform linux/amd64 \
    -f Dockerfile.alpine.vaapi \
    -t datarhei/base:$OS_NAME-ffmpeg-vaapi-$OS_VERSION-$FFMPEG_VERSION .
}

main() {
  if [[ $# == 0 ]]; then
    echo "Options available: default, rpi, cuda, vaapi"
    exit 0
  else
    if [[ $1 == "default" ]]; then
      build_default
    elif [[ $1 == "rpi" ]]; then
      build_rpi
    elif [[ $1 == "cuda" ]]; then
      build_cuda
    elif [[ $1 == "vaapi" ]]; then
      build_vaapi
    fi
  fi
}

main $@

exit 0
