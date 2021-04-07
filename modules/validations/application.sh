#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status

_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_proxy_details=${3} 

_application_name=${4}

# Check if application exists
echo "VAL|Checking if '${_application_name}' business application exist in '${_controller_url}'..."

allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON ${_proxy_details})

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

#appId=$(jq '.id' <<<$applicationObject)

echo "VAL||Found ${_application_name} business application."