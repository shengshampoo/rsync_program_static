
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

# libressl
cd $WORKSPACE
aa=4.2.1
curl -sL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$aa.tar.gz | tar x --gzip
cd libressl-$aa
LDFLAGS="-static -no-pie -s" ./configure --prefix=/usr --disable-tests -disable-shared --enable-static
make
make install

# xxHash
cd $WORKSPACE
git clone https://github.com/Cyan4973/xxHash.git
cd xxHash
make
make install PREFIX=/usr

# rsync
cd $WORKSPACE
aa=3.4.1
curl -sL https://download.samba.org/pub/rsync/src/rsync-$aa.tar.gz | tar x --gzip
cd rsync-$aa
if [ $(uname -m) == "x86_64" ]; then
LDFLAGS="-static --static -no-pie -s"  ./configure --prefix=/usr/local/rsyncmm --disable-roll-simd --enable-roll-asm --enable-md5-asm --enable-ipv6 --enable-acl-support --disable-md2man
elif [ $(uname -m) == "aarch64" ]; then
LDFLAGS="-static --static -no-pie -s"  ./configure --prefix=/usr/local/rsyncmm --disable-roll-simd --enable-roll-asm --enable-ipv6 --enable-acl-support --disable-md2man
else
 exit 1
fi 
make
make install


cd /usr/local
tar vcJf ./rsyncmm.tar.xz rsyncmm

mv ./rsyncmm.tar.xz /work/artifact/
