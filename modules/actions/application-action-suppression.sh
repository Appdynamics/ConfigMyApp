#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status, func_check_http_response
source ./modules/common/application.sh # func_get_application_id

# 1. INPUT PARAMETERS
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

actions_proxy_details=${3}

_application_name=${4}

_action_suppression_start=${5}
_action_suppression_duration=${6} 

_action_suppression_name=${7}

_debug=${8}

function func_check_http_response(){ # override default
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
        exit 1
    fi
}

# 3. PREPARE REQUEST
dt=$(date '+%Y-%m-%d_%H-%M-%S')

_payload_path="./api_actions/actions/action-suppression-payload-${dt}.json"
_template_path="./api_actions/action-suppression-payload-template.json"

_header="Content-Type: application/json; charset=utf8"

if [[ -z "${_action_suppression_name}" ]]; then
    _action_suppression_name="CMA-suppression-${dt}"
fi

echo | date -d "today" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    # GNU
    _action_suppression_end=$(date -d "${_action_suppression_start} +${_action_suppression_duration} minutes" "+%FT%T+0000")
else
    # Mac
    _action_suppression_end=$(date -j -v +${_action_suppression_duration}M -f "%Y-%M-%dT%H:%M:%S+0000" "${_action_suppression_start}" "+%FT%T+0000")
fi

# populate the payload template
sed -e "s/_action_suppression_name/${_action_suppression_name}/g" -e "s/_action_suppression_start/${_action_suppression_start}/g" -e "s/_action_suppression_end/${_action_suppression_end}/g" "${_template_path}" > "${_payload_path}"

## get application id
appId=$(func_get_application_id "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}")

_resource_url="alerting/rest/v1/applications/${appId}/action-suppressions"

# 4. SEND A CREATE REQUEST
echo "Uploading '"${_action_suppression_name}"' application supression action..."
response=$(curl -s -X POST --user $_user_credentials $_controller_url/$_resource_url -H "${_header}" --data "@${_payload_path}" ${_proxy_details} )

# 5. CHECK RESULT
expected_response='"id":' # returns id on success
func_check_http_response "\{$response}" "${expected_response}" "${_payload_path}" "${_action_suppression_name}.json"

#fileName="$(basename -- $_payload_path)"
#cp -rf "$_payload_path" "./api_actions/uploaded/${fileName}.${dt}"
 
#echo "response is: $response"