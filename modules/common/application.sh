#!/bin/bash

function func_get_application_id() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}

    local _application_name=${3}
    local _proxy_details=${4} 

    # Get all applications
    allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON ${_proxy_details})

    #echo "_proxy_details $_proxy_details | _application_name $_application_name"

    # Select by name
    applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

    if [ "$applicationObject" = "" ]; then
        exit 1
    fi

    appId=$(jq '.id' <<<$applicationObject)

    echo "${appId}"

}

