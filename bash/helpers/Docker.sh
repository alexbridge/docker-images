#!/usr/bin/env bash

if [[ ! -v __INCLUDE_DOCKER_SH__ ]]; then __INCLUDE_DOCKER_SH__=true

function Docker::waitForHealthCheck() {
  declare container="${1}" sleepSec=1

  ATTEMPTS=0
  STATE=$(docker inspect --format='{{json .State.Health.Status}}' "$container")
  while [[ "${STATE}" != '"healthy"' ]]; do
    if [ "$ATTEMPTS" -eq "500" ]; then
      Echo::error "Container $container not ready after $ATTEMPTS seconds. Aborting ..."
      exit 1
    fi
    ATTEMPTS=$(($ATTEMPTS + $sleepSec))
    STATE=$(docker inspect --format='{{json .State.Health.Status}}' "$container")
    echo -ne "Waiting for ${container} to become ready ${ATTEMPTS} / 500 : ${STATE} \r"
    sleep $sleepSec
  done
  Echo::info ""
  Echo::info "Container $container is ready after $ATTEMPTS seconds."
}

function Docker::stopContainerByName() {
  declare name="${1}"

  docker container stop -t 30 "$(docker container ls -q --filter name="${name}")"
}

function Docker::stopContainers() {
  declare names="${1}"

  docker container stop -t 30 "${names}"
}

function Docker::pruneImages() {
  declare days="${1}"

  local hours=$(( days * 24 ))

  Echo::info "Pruning docker images older than ${days} days."
  docker image prune -af --filter "until=${hours}h"
}

function Docker::findByLabel() {
  declare key="${1}" value="${2}"

  docker ps --filter "label=${key}=${value}" --format "{{.ID}}"
}

fi