#!/bin/bash

DEFAULT_PATH=${HOME}/.ssh/nh32001_id_rsa

SSH_PATH=${1-${DEFAULT_PATH}}
echo $SSH_PATH

if [ -f $SSH_PATH ];
then
    echo "file exist"
else
    echo "file not exist"
    exit 9
fi


VERSION=v0.0.1
CONTAINER=wallet

HOST_PORT=9000
HOST_ROOT_DIR=$(pwd)/${CONTAINER}

DOCKER_PORT=9000

echo ${VERSION}
echo ${HOST_ROOT_DIR}

MY_KEY=$(cat ${SSH_PATH})
# echo ${MY_KEY}

docker build \
	--force-rm=true \
	--rm=true \
	--tag ${CONTAINER}:${VERSION} \
	--build-arg SSH_KEY="$MY_KEY" \
	--build-arg VERSION=${VERSION} \
	--build-arg CONTAINER=${CONTAINER} \
	--build-arg HOST_ROOT_DIR=${HOST_ROOT_DIR} \
	--build-arg DOCKER_PORT=${DOCKER_PORT} \
	.

echo "docker build done"

docker run \
	--rm \
	-d \
	--name ${CONTAINER} \
	-p ${HOST_PORT}:${DOCKER_PORT} \
	-v ${HOST_ROOT_DIR}:/work \
	${CONTAINER}:${VERSION}

echo "docker run done"