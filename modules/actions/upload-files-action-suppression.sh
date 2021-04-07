#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status, func_check_http_response
source ./modules/common/application.sh # func_get_application_id

# 1. INPUT PARAMETERS
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_proxy_details=${3} 

_application_name=${4}

_debug=${5}

dt=$(date '+%Y-%m-%d_%H-%M-%S')

# http header
_header="Content-Type: application/json; charset=utf8"

# actions directory
_action_suppression_files="./api_actions/actions/*.json"

# 2. FUNCTIONS
function func_check_http_response(){ # function override
    local http_message_body="$1"
    local string_success_response_contains="$2"
    local filePath="$3"
    local fileName="$4"
    if [[ "$http_message_body" =~ "$string_success_response_contains" ]]; then # contains
        cp -rf "$filePath" "./api_actions/uploaded/${fileName}.${dt}"
        echo "Success..."
    else
        echo "${dt} ERROR "{$http_message_body}"" >> error.log
        echo "ERROR $http_message_body"
        # do not break on failure
    fi
}

# 3. PREPARE REQUEST

# get application id
appId=$(func_get_application_id ${_controller_url} ${_user_credentials} ${_application_name} ${_proxy_details})

resourceUrl="alerting/rest/v1/applications/${appId}/action-suppressions"

for f in $_action_suppression_files; do
    
    # Check if folder contains files
    [ -f "$f" ] || func_check_http_status 404 "No files found that match pattern: '"$_action_suppression_files"'. Aborting..."

    echo "Processing '"$f"' action suppression file"

    payloadPath=$f

    # 4. SEND A CREATE REQUEST
    response=$(curl -s -X POST --user $_user_credentials $_controller_url/$resourceUrl -H "${_header}" --data "@${payloadPath}" ${_proxy_details})

    # 5. CHECK RESULT
    expectedResponse='"id":' # returns id on success
    fileName="$(basename -- $f)"
    func_check_http_response "\{$response}" "${expectedResponse}" ${payloadPath} "${fileName}"

    # echo "response is: $response"

done
 
