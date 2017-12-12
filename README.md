# FFmpeg
FFmpeg Development Image for H.264-Processing (e.g. RTMP, HLS)

* Alpine Linux (3.6)
* FFmpeg
* Docker-Images for AMD64, ARMHF (e.g. Raspberry-Pi) and AARCH64 (e.g. Pine64)

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
    --disable-ffserver
```

* `3.4.1`, `3.4`, `3` (docker pull `datarhei/ffmpeg:3.4`)  
* `3.3.5`, `3.3` (docker pull `datarhei/ffmpeg:3.3`)
* `3.3.5-armhf`, `3.3-armhf`, `3-armhf` (docker pull `datarhei/ffmpeg:3.3-armhf`)
* `3.3.5-aarch64`, `3.3-aarch64`, `3-aarch64` (docker pull `datarhei/ffmpeg:3.3-aarch64`)
* `3.2.9`, `3.2` (docker pull `datarhei/ffmpeg:3.2`)
* `3.2.9-armhf`, `3.2-armhf` (docker pull `datarhei/ffmpeg:3.2-armhf`)
* `3.2.9-aarch64`, `3.2-aarch64` (docker pull `datarhei/ffmpeg:3.2-aarch64`)
* `3.1.11`, `3.1` (docker pull `datarhei/ffmpeg:3.1`)
* `3.1.11-armhf`, `3.1-armhf` (docker pull `datarhei/ffmpeg:3.1-armhf`)
* `3.1.11-aarch64`, `3.1-aarch64` (docker pull `datarhei/ffmpeg:3.1-aarch64`)
* `3.0.10`, `3.0` (docker pull `datarhei/ffmpeg:3.0`)
* `3.0.10-armhf`, `3.0-armhf` (docker pull `datarhei/ffmpeg:3.0-armhf`)
* `3.0.10-aarch64`, `3.0-aarch64` (docker pull `datarhei/ffmpeg:3.0-aarch64`)
* `2.8.13`, `2.8`, `2` (docker pull `datarhei/ffmpeg:2.8`)
* `2.8.13-armhf`, `2.8-armhf`, `2-armhf` (docker pull `datarhei/ffmpeg:2.8-armhf`) 
* `2.8.13-aarch64`, `2.8-aarch64`, `2-aarch64` (docker pull `datarhei/ffmpeg:2.8-aarch64`) 

## Build your own Image

```sh
docker build -t ffmpeg:amd64 \
     --build-arg ALPINE_IMAGE=alpine:latest \
     --build-arg FFMPEG_VERSION=3.3.5 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20171211-2245-stable .
             
docker build -t ffmpeg:armhf \
     --build-arg ALPINE_IMAGE=resin/armhf-alpine:latest \
     --build-arg FFMPEG_VERSION=3.3.5 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20171211-2245-stable .
             
docker build -t ffmpeg:aarch64 \
     --build-arg ALPINE_IMAGE=resin/aarch64-alpine:latest \
     --build-arg FFMPEG_VERSION=3.3.5 \
     --build-arg FDKAAC_VERSION=0.1.5 \
     --build-arg LAME_VERSION=3.99.5 \
     --build-arg X264_VERSION=20171211-2245-stable .
```