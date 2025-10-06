FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required rsync 
RUN apk add --no-cache \
  gcc make linux-headers musl-dev zlib-dev zlib-static \
  python3-dev curl acl-dev acl-static zstd-static zstd-dev \
  lz4-static lz4-dev git bash xz

ENV XZ_OPT=-e9
COPY build-static-rsync.sh build-static-rsync.sh
RUN chmod +x ./build-static-rsync.sh
RUN bash ./build-static-rsync.sh
