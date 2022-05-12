# FFmpeg Base
FFmpeg base image for [datarhei/core](https://github.com/datarhei/core).

## Config:
```sh
--enable-libfreetype
--enable-libsrt
--enable-libx264
--enable-libx265
--enable-libvpx
--enable-libmp3lame
--enable-libopus
--enable-libvorbis
```
*Additional informations can be found in the Dockerfiles.*

## Patches:
- JSON-Stats (expands progress data per file in json format)

## Images and Plattforms:
Dockerimage | OS | Plattform | GPU
-----------|----|-----------|----
docker.io/datarhei/ffmpeg:latest | Alpine 3.15 | linux/amd64, linux/arm64, linux/arm/v7 | -
docker.io/datarhei/ffmpeg:rpi-latest | Alpine 3.15 | Raspberry Pi (linux/arm/v7) | MMAL/OMX
docker.io/datarhei/ffmpeg:vaapi-latest | Alpine 3.15 | linux/amd64 | Intel VAAPI

## Testing
```sh
$ docker buildx create builder
$ docker buildx use builder
$ docker buildx inspect builder --bootstrap
$ docker buildx build --platform linux/amd64 linux/arm64 linux/arm/v7 -f Dockerfile -t ffmpeg:dev --load .
$ docker buildx rm builder
```

## Known problems:
The libraries are currently not compiled due to errors caused by Docker virtualisation. 

## Feature requests:
Please create an issue with your use case and all the requirements.

## Licence
LGPL-licensed with optional components licensed under GPL. Please refer to the LICENSE file for detailed information.
