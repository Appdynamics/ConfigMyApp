#!/bin/bash

# intent to be internal
function func_log_error_to_file(){
    local message="$1"
    local severity="$2" # optional, error by default
    local status_code="$3" # optional

    dt=$(date '+%Y-%m-%d_%H-%M-%S')

    if [[ -z "$severity" ]]; then
        severity="ERROR"
    fi

    if [[ ! -z "$status_code" ]]; then
        status_code="'$status_code' "
    fi

    echo "${dt} ${severity} ${status_code}"${message}"" >> error.log
}