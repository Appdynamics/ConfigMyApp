#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh # func_get_application_id



function func_get_all_groups() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    _endpoint_url="/api/rbac/v1/groups"
    _method="GET"
    if [[ _debug = true ]]; then _output="-v"; else _output="-s"; fi

    echo "curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}${_endpoint_url} ${_proxy_details}"

    # Get all groups
    groups=$(curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}${_endpoint_url} ${_proxy_details})

    echo "${groups}"

}

function func_get_group_id_by_name() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    local _group_name=${7}

    _endpoint_url="/api/rbac/v1/groups"
    _method="GET"
    _endpoint_url="${_endpoint_url}/name/${_group_name}"
    if [ $_debug = true ]; then _output="-v"; else _output="-s"; fi

    # Get group by name
    group=$(curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    group_id=$(jq '.[] | select(.id)' <<<$group)

    if [ "$group_id" = "" ]; then
        func_check_http_status 404 "Group name ${_group_name} not found."
    fi

    echo "${group_id}"

}


function func_create_group() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${5}

    local _group_name=${6}
    local _group_description=${7}
    local _group_security_provider_type="INTERNAL"

    if [ ! -z "${_group_name// }" ]; then

        _endpoint_url="/api/rbac/v1/groups"
        _method="POST"
        _header="Content-Type: application/vnd.appd.cntrl+json;v=1"

        _payload="{\"name\": \"${_group_name}\",\"description\": \"${_group_description}\",\"security_provider_type\": \"${_group_security_provider_type}\"}"

        if [[ $_debug = true ]]; then _output="-v"; else _output="-s"; fi

        echo "curl ${_output} -X ${_method} -H "\"${_header}\"" -d "\'${_payload}\'" --user ${_user_credentials} ${_controller_url}${_endpoint_url} ${_proxy_details}"
    
        httpCode=$(curl ${_output} -o /dev/null -w "%{http_code}" -X ${_method} -H "\"${_header}\"" -d "\'${_payload}\'" --user ${_user_credentials} ${_controller_url}${_endpoint_url} ${_proxy_details})
        func_check_http_status $httpCode "Error occured creating group '${_group_name}'."
    else
        func_check_http_status 404 "Group name must be provided."
    fi

    echo "Group created: '${_group_name}'"

}

