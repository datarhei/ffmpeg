# FFmpeg
FFmpeg Development Image for H.264-Processing (e.g. RTMP, HLS)

* Alipne Linux (3.6)
* FFmpeg
* Docker-Images for AMD64 and ARMhf (e.g. Raspberry-Pi)

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

## Published Images

* **3.3.3**  
  docker pull `datarhei/ffmpeg:3.3.3`  
  docker pull `datarhei/ffmpeg:3.3.3-armhf`
* **3.2.7**   
  docker pull `datarhei/ffmpeg:3.2.7`   
  docker pull `datarhei/ffmpeg:3.2.7-armhf`
* **3.1.7**  
  docker pull `datarhei/ffmpeg:3.1.9`   
  docker pull `datarhei/ffmpeg:3.1.9-armhf`
* **3.0.7**  
  docker pull `datarhei/ffmpeg:3.0.9`   
  docker pull `datarhei/ffmpeg:3.0.9-armhf`
* **2.8.7**  
  docker pull `datarhei/ffmpeg:2.8.12`   
  docker pull `datarhei/ffmpeg:2.8.12-armhf`
