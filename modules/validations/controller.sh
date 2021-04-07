#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status

_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_proxy_details=${3} 

# Check if you can connect to a controler
echo "VAL|Checking connection to controller '${_controller_url}'..."

# timeout after 10s
controllerReponse=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications ${_proxy_details} --connect-timeout 10)

if [ "$controllerReponse" = "" ]; then
    func_check_http_status 404 "Unable to connect to controller: '"$_controller_url"'. Aborting..."
fi

echo "VAL||Succesfully reached '${_controller_url}'."