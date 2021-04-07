#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status, func_check_http_response
source ./modules/common/application.sh # func_get_application_id

# 1. INPUT PARAMETERS
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_proxy_details=${3} 

_application_name=${4}

_action_suppression_name=${5}

_debug=${6}

# 3. PREPARE REQUEST

# 3.1 Get application id
appId=$(func_get_application_id "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}")

# 3.2 Get suppression id
actionSupressions=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/action-suppressions ${_proxy_details})

actionSupressionObject=$(jq --arg suppressionName "$_action_suppression_name" '.[] | select(.name == $suppressionName)' <<< $actionSupressions)

if [ "$actionSupressionObject" = "" ]; then
    func_check_http_status 404 "Action supression '"$_action_suppression_name"' not found. Aborting..."
fi

action_supression_id=$(jq '.id' <<< $actionSupressionObject)

# 3.3 Set request url
_resource_url="alerting/rest/v1/applications/${appId}/action-suppressions/${action_supression_id}"

# 4. SEND A DELETE REQUEST
echo "Deleting '"$_action_suppression_name"' application supression action..."
# response is always empty
response=$(curl -s -X DELETE --user $_user_credentials $_controller_url/$_resource_url ${_proxy_details})

echo "Done."
