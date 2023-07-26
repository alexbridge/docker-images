#!/usr/bin/env bash

if [[ ! -v __INCLUDE_ECHO_SH__ ]]; then __INCLUDE_ECHO_SH__=true

function Echo::error() {
    if [[ $1 == "-n" ]]; then
        opts="en"
        shift 1
    else
        opts="e"
    fi

    declare msg="$*"

    local red="$(Color::getRedBold)"
    local clear="$(Color::getClearCode)"

    if [[ -t 2 ]]
    then
        (>&2 echo -${opts} "ERROR: ${red}${msg}${clear}")
    else
        (>&2 echo -${opts} "ERROR: ${msg}")
    fi
}

function Echo::success() {
    if [[ $1 == "-n" ]]; then
        opts="en"
        shift 1
    else
        opts="e"
    fi

    declare msg="$*"

    local green="$(Color::getGreenBold)"
    local clear="$(Color::getClearCode)"

    if [[ -t 1 ]]
    then
        echo -${opts} "SUCCESS: ${green}${msg}${clear}"
    else
        echo -${opts} "SUCCESS: ${msg}"
    fi
}

function Echo::notice() {
    if [[ $1 == "-n" ]]; then
        opts="en"
        shift 1
    else
        opts="e"
    fi

    declare msg="$*"

    local yellow="$(Color::getCian)"
    local clear="$(Color::getClearCode)"

    if [[ -t 2 ]]
    then
        (>&2 echo -${opts} "NOTICE: ${yellow}${msg}${clear}")
    else
        (>&2 echo -${opts} "NOTICE: $msg")
    fi
}

function Echo::info() {
    if [[ $1 == "-n" ]]; then
        opts="en"
        shift 1
    else
        opts="e"
    fi

    declare msg="$*"

    local yellow="$(Color::getYellow)"
    local clear="$(Color::getClearCode)"

    if [[ -t 2 ]]
    then
        (>&2 echo -${opts} "INFO: ${yellow}${msg}${clear}")
    else
        (>&2 echo -${opts} "INFO: $msg")
    fi
}

function Echo::withSeparator() {
  declare title="${1}" content="${2}"

  local yellowBold="$(Color::getYellowBold)"
  local yellow="$(Color::getYellow)"
  local clear="$(Color::getClearCode)"

  cat <<EOF
---- ${yellowBold}${title^^}${clear} ------
${content}
-----${yellow}${title,,}${clear} -------
EOF
}


fi