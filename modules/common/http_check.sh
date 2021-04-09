#!/bin/bash

source ./modules/common/sensitive_data.sh # func_data_masking
source ./modules/common/logging.sh # func_log_error_to_file

# external
function func_check_http_status() {
    local http_code=$1
    local message_on_failure=$2
    #echo "HTTP status code: $http_code"
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo "ERROR $http_code: $message_on_failure"
        # mask sensitive info (if needed)
        message_on_failure=$(func_data_masking "${message_on_failure}" "" "")
        logged_to_file=$(func_log_error_to_file "${message_on_failure}" "ERROR" "$http_code")
        exit 1
    fi
}

function func_check_http_response(){
    local http_message_body="$1"
    local string_success_response_contains="$2"
    if [[ "$http_message_body" =~ "$string_success_response_contains" ]]; then # contains
        echo "*********************************************************************"
        echo "Success"
        echo "*********************************************************************"
    else
        echo "ERROR HTTP response does not contain '$string_success_response_contains'. Check logs for mode detils..."
        # mask sensitive info (if needed)
        http_message_body=$(func_data_masking "${http_message_body}" "" "")
        logged_to_file=$(func_log_error_to_file "${http_message_body}" "ERROR")
        exit 1
    fi
}

function func_cleanup() {
    tempFolder=$1
    # remove all from temp folder
    rm -rf $tempFolder
}