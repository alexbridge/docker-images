FROM alpine:3.19.1

WORKDIR /opt/ansible

RUN apk add --no-cache make bash ansible-core

RUN ansible-galaxy collection install community.general
RUN ansible-galaxy collection install community.docker
