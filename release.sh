#!/bin/bash

set -xe

commitid=$(git log -n 1 --pretty --format=%h)
release_ver=5.0

build::local(){
    release_desc=${release_ver}-${commitid}
    sed "s/__RELEASE_DESC__/$release_desc/" Dockerfile >Dockerfile.release
    docker build --no-cache -t goodrain.me/builder -f Dockerfile.release .
    rm -rf Dockerfile.release
    [ "$1" == "push" ] && docker push goodrain.me/builder
}

build::public(){
    docker tag goodrain.me/builder rainbond/rbd-builder:${release_ver}
}

case $1 in
    local)
        build::local ${@:2}
    ;;
    *)
        build::local
        build::public
    ;;
esac