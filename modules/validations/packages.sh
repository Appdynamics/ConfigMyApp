#!/bin/bash

echo "VAL|Checking if all necessary packages are installed..."

[[ "$(command -v jq)" ]] || {
    echo "jq is not installed, download it from - https://stedolan.github.io/jq/download/ and try again after installing it. Aborting..." 1>&2
    sleep 5
    exit 1
}

[[ "$(command -v base64)" ]] || {
    echo "base64 is not installed. Please ensure that you have 'base64' installed on this machine. Aborting..." 1>&2
    sleep 5
    exit 1
}

[[ "$(command -v awk)" ]] || {
    echo "awk is not installed, ConfigMyApp requires awk to be installed. Aborting..." 1>&2
    sleep 5
    exit 1
}

echo "VAL||Done."
