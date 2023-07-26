#!/usr/bin/env bash

if [[ ! -v __INCLUDE_STRING_SH__ ]]; then __INCLUDE_STRING_SH__=true

function Strings::toDashes() {
  declare arg1="${1}"

  echo "${arg1}" | sed 's#/#\-#g' | cut -d '-' -f 1-3 | cut -d '_' -f 1
}

function Strings::startsWith() {
  declare string="${1}" prefix="${2}"

  local length="${#prefix}"
  [[ "${string:0:$length}" = "${prefix}" ]]
}



fi