FROM python:3.7-slim

MAINTAINER nh32001 <nh32001@naver.com>

ARG VERSION
ARG CONTAINER
ARG HOST_ROOT_DIR
ARG DOCKER_PORT

# Take an SSH key as a build argument.
ARG SSH_KEY

# Take an SSH key as a build argument.
ARG SSH_KEY

ADD ${CONTAINER} /work
RUN apt-get update && \
    apt-get install -y git libleveldb1d libleveldb-dev g++

# 1. Create the SSH directory.
# 2. Populate the private key file.
# 3. Set the required permissions.
# 4. Add github to our list of known hosts for ssh.
RUN mkdir -p /root/.ssh/ && \
    echo "$SSH_KEY" > /root/.ssh/id_rsa && \
    chmod -R 600 /root/.ssh/ && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

WORKDIR /src
RUN git clone git@github.com:nh32001/shop_rank_tracker.git /src && \
	./build.sh && \
	pip install dist/${CONTAINER}server*.whl

EXPOSE ${DOCKER_PORT}

WORKDIR /work


HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
      CMD curl -f https://localhost:${DOCKER_PORT} || exit 1

RUN chmod 755 ./entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]