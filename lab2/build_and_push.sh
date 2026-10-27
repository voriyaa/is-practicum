#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <image> [tag]"
    echo "Example: $0 docker.io/username/lab2-app 1.0"
    exit 1
fi

IMAGE=$1
TAG=${2:-1.0}

cd "$(dirname "$0")" || exit 1
docker build -t "$IMAGE:$TAG" . || exit 1
docker push "$IMAGE:$TAG"
