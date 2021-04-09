#!/bin/bash

source ./modules/common/application.sh #func_get_application_id

function func_restui_get_application_guid() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 
    local _application_name=${4} 
    # no application name needed
    local _debug=${5}

    local X_CSRF_TOKEN_HEADER=${6}

    _endpoint_url="/restui/licenseRule/getAllApplications"
    _method="GET"

    allApplications=$(curl -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -X ${_method} "${_controller_url}${_endpoint_url}" ${_proxy_details})

    # Select by name
    applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

    if [ "$applicationObject" = "" ]; then
        echo ""
        exit 0
    fi

    appGuid=$(jq '.objectReference.id' <<<$applicationObject)

    echo "${appGuid}"

}

