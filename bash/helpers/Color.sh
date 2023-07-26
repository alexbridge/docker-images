#!/usr/bin/env bash

if [[ ! -v __INCLUDE_COLOR_SH__ ]]; then __INCLUDE_COLOR_SH__=true

function Color::getEscapeCharacter() {
    echo -ne "\033"
}

function Color::getRed() {
    echo -ne "$(Color::getEscapeCharacter)[0;31m"
}

function Color::getRedBold() {
    echo -ne "$(Color::getEscapeCharacter)[1;31m"
}

function Color::getGreen() {
    echo -ne "$(Color::getEscapeCharacter)[0;32m"
}

function Color::getGreenBold() {
    echo -ne "$(Color::getEscapeCharacter)[1;32m"
}

function Color::getYellow() {
    echo -ne "$(Color::getEscapeCharacter)[0;33m"
}

function Color::getYellowBold() {
    echo -ne "$(Color::getEscapeCharacter)[1;33m"
}

function Color::getBlue() {
    echo -ne "$(Color::getEscapeCharacter)[0;34m"
}

function Color::getBlueBold() {
    echo -ne "$(Color::getEscapeCharacter)[1;34m"
}

function Color::getPink() {
    echo -ne "$(Color::getEscapeCharacter)[0;35m"
}

function Color::getPinkBold() {
    echo -ne "$(Color::getEscapeCharacter)[1;35m"
}

function Color::getCian() {
    echo -ne "$(Color::getEscapeCharacter)[0;36m"
}

function Color::getCianBold() {
    echo -ne "$(Color::getEscapeCharacter)[1;36m"
}

function Color::getWhite() {
    echo -ne "$(Color::getEscapeCharacter)[0;37m"
}

function Color::getWhiteBold() {
    echo -ne "$(Color::getEscapeCharacter)[1;37m"
}

function Color::getClearCode() {
    echo -ne "$(Color::getEscapeCharacter)[0m"
}

# expects input to get piped in
function Color::removeColorCodes() {
    sed -r 's/[[:cntrl:]][[0-9]{1,3};[0-9]{1,3}m//g'
}

fi