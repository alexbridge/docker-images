#!/usr/bin/env bash

if [[ ! -v __INCLUDE_UTILS_SH__ ]]; then __INCLUDE_UTILS_SH__=true

function Utils::requireVar() {
  declare var="${1}"

  Utils::isEmptyExit "${!var}" "Variable \$${var} is empty"
  echo "${!var}"
}

function Utils::isEmptyExit() {
  declare var="${1}" message="${2}"

  if [ -z "$var" ]; then
    Echo::error "\n\t ${message}. Aborting.. \n"
    exit 1
  fi
}

function Utils::notDigitsExit() {
  declare var="${1}" message="${2}"

  local re='^[0-9]+$'
  if ! [[ $var =~ $re ]] ; then
    Echo::error "\n\t ${message} [${var}] contains non digits. Aborting.. \n"
    exit 1
  fi
}

function Utils::sleep() {
  declare seconds="${1:-30}" message="${2:-}"

  Echo::info "Waiting ${seconds} seconds: ${message}"
  sleep "$seconds"
}

function Utils::tryCommand() {
  declare message="${1:-unknown}"
  (
    set -e
    bash -s
  )
  errorCode=$?
  if [ "$errorCode" -gt 0 ]; then
      echo "Error $errorCode: ${message}"
      return $errorCode
  fi
}

function Utils::trap() {
    local err=$?
    Echo::error "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}."
    Echo::error "'${BASH_COMMAND}' exited with status $err"
    exit $err
}

fi