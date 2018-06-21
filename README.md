# FFmpeg
FFmpeg Development Image for H.264-Processing (e.g. RTMP, HLS)

* Alpine Linux (3.7)
* FFmpeg
* Docker-Images for AMD64/X86, ARMHF (e.g. Raspberry-Pi) and AARCH64 (e.g. Pine64)

```sh
./configure
    --enable-nonfree
    --enable-gpl
    --enable-version3
    --enable-avresample
    --enable-libmp3lame
    --enable-libx264
    --enable-openssl
    --enable-postproc
    --enable-small
    --enable-libfdk_aac
    --enable-shared
    --disable-debug
    --disable-doc
    --disable-static
    --disable-ffserver (removed in v4)
```

* `4.0`, `4` (docker pull `datarhei/ffmpeg:4.0`)
* `4.0-armhf`, `4-armhf` (docker pull `datarhei/ffmpeg:4.0-armhf`)
* `4.0-aarch64`, `4-aarch64` (docker pull `datarhei/ffmpeg:4.0-aarch64`)
* `3.4.2`, `3.4`, `3` (docker pull `datarhei/ffmpeg:3.4`)  
* `3.3.7`, `3.3` (docker pull `datarhei/ffmpeg:3.3`)
* `3.3.7-armhf`, `3.3-armhf`, `3-armhf` (docker pull `datarhei/ffmpeg:3.3-armhf`)
* `3.3.7-aarch64`, `3.3-aarch64`, `3-aarch64` (docker pull `datarhei/ffmpeg:3.3-aarch64`)
* `3.2.10`, `3.2` (docker pull `datarhei/ffmpeg:3.2`)
* `3.2.10-armhf`, `3.2-armhf` (docker pull `datarhei/ffmpeg:3.2-armhf`)
* `3.2.10-aarch64`, `3.2-aarch64` (docker pull `datarhei/ffmpeg:3.2-aarch64`)
* `3.1.11`, `3.1` (docker pull `datarhei/ffmpeg:3.1`)
* `3.1.11-armhf`, `3.1-armhf` (docker pull `datarhei/ffmpeg:3.1-armhf`)
* `3.1.11-aarch64`, `3.1-aarch64` (docker pull `datarhei/ffmpeg:3.1-aarch64`)
* `3.0.11`, `3.0` (docker pull `datarhei/ffmpeg:3.0`)
* `3.0.11-armhf`, `3.0-armhf` (docker pull `datarhei/ffmpeg:3.0-armhf`)
* `3.0.11-aarch64`, `3.0-aarch64` (docker pull `datarhei/ffmpeg:3.0-aarch64`)
* `2.8.14`, `2.8`, `2` (docker pull `datarhei/ffmpeg:2.8`)
* `2.8.14-armhf`, `2.8-armhf`, `2-armhf` (docker pull `datarhei/ffmpeg:2.8-armhf`) 
* `2.8.14-aarch64`, `2.8-aarch64`, `2-aarch64` (docker pull `datarhei/ffmpeg:2.8-aarch64`) 

## Build your own Image

#### FFmpeg 4+
```sh
docker build -f Dockerfile_FFmpeg_4 -t ffmpeg:amd64 \
     --build-arg ALPINE_IMAGE=alpine:latest \
     --build-arg FFMPEG_VERSION=4.0 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20180607-2245-stable .
             
docker build -f Dockerfile_FFmpeg_4 -t ffmpeg:armhf \
     --build-arg ALPINE_IMAGE=resin/armhf-alpine:latest \
     --build-arg FFMPEG_VERSION=4.0 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20180607-2245-stable .
             
docker build -f Dockerfile_FFmpeg_4 -t ffmpeg:aarch64 \
     --build-arg ALPINE_IMAGE=resin/aarch64-alpine:latest \
     --build-arg FFMPEG_VERSION=4.0 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20180607-2245-stable .
```

#### FFmpeg 2-3
```sh
docker build -f Dockerfile_FFmpeg_2-3 -t ffmpeg:amd64 \
     --build-arg ALPINE_IMAGE=alpine:latest \
     --build-arg FFMPEG_VERSION=3.3.7 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20180607-2245-stable .
             
docker build -f Dockerfile_FFmpeg_2-3 -t ffmpeg:armhf \
     --build-arg ALPINE_IMAGE=resin/armhf-alpine:latest \
     --build-arg FFMPEG_VERSION=3.3.7 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20180607-2245-stable .
             
docker build -f Dockerfile_FFmpeg_2-3 -t ffmpeg:aarch64 \
     --build-arg ALPINE_IMAGE=resin/aarch64-alpine:latest \
     --build-arg FFMPEG_VERSION=3.3.7 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20180607-2245-stable .
```