FROM alpine:latest

CMD ["--help"]
ENTRYPOINT  ["ffmpeg"]
WORKDIR /tmp/workdir

ENV FDKAAC_VERSION=0.1.5 \
    LAME_VERSION=3.99.5 \
    X264_VERSION=20170226-2245-stable \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    SRC=/usr/local

ARG FFMPEG_VERSION="2.8.11"
ARG FFMPEG_KEY="D67658D8"

RUN buildDeps="autoconf \
        automake \
        bash \
        binutils \
        bzip2 \
        cmake \
        curl \
        coreutils \
        g++ \
        gcc \
        gnupg \
        libtool \
        make \
        python \
        openssl-dev \
        tar \
        yasm \
        zlib-dev" && \
    export MAKEFLAGS="-j$(($(grep -c ^processor /proc/cpuinfo) + 1))" && \
    apk update && \
    apk upgrade && \
    apk add --update ${buildDeps} libgcc libstdc++ ca-certificates libssl1.0 && \
    
    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-pic --enable-shared --disable-cli && \
    make && \
    make install && \
    rm -rf ${DIR} && \

    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://downloads.sf.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --enable-nasm --datarootdir="${DIR}" && \
    make && \
    make install && \
    rm -rf ${DIR} && \

    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    autoreconf -fiv && \
    ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
    make && \
    make install && \
    make distclean && \
    rm -rf ${DIR} && \
                
    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sLO http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    ./configure \
        --bindir="${SRC}/bin" \
        --extra-libs=-ldl \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --extra-libs=-ldl \
        --prefix="${SRC}" \
        --enable-nonfree \
        --enable-gpl \
        --enable-version3 \
        --enable-avresample \
        --enable-libmp3lame \
        --enable-libx264 \
        --enable-openssl \
        --enable-postproc \
        --enable-small \
        --enable-libfdk_aac \
        --enable-shared \
        --disable-debug \
        --disable-doc \
        --disable-static \
        --disable-ffserver && \
    make && \
    make install && \
    make distclean && \
    hash -r && \
    cd tools && \
    make qt-faststart && \
    cp qt-faststart ${SRC}/bin && \
    rm -rf ${DIR} && \

    cd && \
    apk del ${buildDeps} && \
	rm -rf /var/cache/apk/* /usr/local/include && \
    ffmpeg -buildconf