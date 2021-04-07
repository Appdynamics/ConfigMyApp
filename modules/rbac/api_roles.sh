#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh # func_get_application_id



function func_get_all_roles() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    if [[ _debug = true ]]; then echo ">> func_get_all_roles"; fi

    _endpoint_url="/api/rbac/v1/roles"
    _method="GET"
    if [[ _debug = true ]]; then _output="-v"; else _output="-s"; fi

    # Get all roles
    allRoles=$(curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    echo "${allRoles}"

}

function func_get_role_by_name() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 
    
    local _application_name=${4}
    local _debug=${5}

    local _role_name=${6}

    _endpoint_url="/api/rbac/v1/roles/name/${_role_name}"
    _method="GET"
    if [[ _debug = true ]]; then _output="-v"; else _output="-s"; fi

    # Get all roles
    response=$(curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    echo "${response}"

}

function func_create_role() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    local _role_name=${7}
    local _role_description=${8}

    if [[ _debug = true ]]; then echo ">> func_create_role"; fi

    if [ ! -z "${_role_name// }" ]; then

        _endpoint_url="/api/rbac/v1/roles"
        _method="POST"
        _header="Content-Type: application/vnd.appd.cntrl+json;v=1"
        _payload="{\"name\": \"${_role_name}\",\"description\": \"${_role_description}\"}"
        if [ $_debug = true ]; then _output="-v"; else _output="-s"; fi
    
        httpCode=$(curl ${_output} -o /dev/null -w "%{http_code}" -X ${_method} -H "${_header}" -d "${_payload}" --user ${_user_credentials} ${_controller_url}${_endpoint_url} ${_proxy_details})
        func_check_http_status $httpCode "Error occured creating a role '${_role_name}'."
    else
        func_check_http_status 404 "Role name must be provided."
    fi

    echo "Role created '${_role_name}'"

}

function func_add_role_to_group() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    local _role_id=${7}
    local _group_id=${8}

    if [[ _debug = true ]]; then echo ">> func_add_role_to_group"; fi

    _endpoint_url="/api/rbac/v1/roles"
    _method="PUT"
    _header="Content-Type: application/vnd.appd.cntrl+json;v=1"
    _endpoint_url="${_endpoint_url0}/${_role_id}/groups/${_group_id}"
    if [ $_debug = true ]; then _output="-v"; else _output="-s"; fi

    # Add role to a group
    response=$(curl ${_output} -X ${_method} -H "${_header}" --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})
    #func_check_http_status $httpCode "Error occured adding role '${_role_id}' to a group '${_group_id}'."

    echo "${response}"

}


