ARG ALPINE_IMAGE=alpine:latest

FROM $ALPINE_IMAGE as builder

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    SRC=/usr/local

ARG FDKAAC_VERSION=0.1.5
ARG LAME_VERSION=3.99.5
ARG X264_VERSION=20170807-2245-stable
ARG FFMPEG_VERSION="2.8.12"

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

    DIR=$(mktemp -d) && cd ${DIR} && \
    LAME_GIT_VERSION=$(echo ${LAME_VERSION} | tr '.' '_') && \
    curl -sL https://github.com/rbrito/lame/archive/RELEASE__${LAME_GIT_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --enable-nasm --datarootdir="${DIR}" && \
    make && \
    make install && \

    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    autoreconf -fiv && \
    ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
    make && \
    make install && \
                
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
    hash -r
    
FROM $ALPINE_IMAGE

COPY --from=builder /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=builder /usr/local/bin/ffprobe /usr/local/bin/ffprobe
COPY --from=builder /usr/local/lib /usr/local/lib

RUN apk add --update libssl1.0 && \
    ffmpeg -buildconf

CMD ["--help"]
ENTRYPOINT  ["ffmpeg"]
WORKDIR /tmp/ffmpeg