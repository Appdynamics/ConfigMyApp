#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh # func_get_application_id



function func_get_all_users() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${5}

    _endpoint_url="/api/rbac/v1/users"

    if [[ _debug = true ]]; then _output="-v"; else _output="-s"; fi

    # Get all applications
    allUsers=$(curl -s --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    echo "${allUsers}"

}

function func_get_user_by_id() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${5}

    local _user_id=${6}

    echo "user id is ${_user_id}"

    _endpoint_url="/api/rbac/v1/users"
    _method="GET"
    _endpoint_url="${_endpoint_url}/${_user_id}"
    if [[ _debug = true ]]; then _output="-v"; else _output="-s"; fi

    echo "endpoint is ${_endpoint_url}"

    # Get group by name
    user=$(curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    echo "${user}"

}

