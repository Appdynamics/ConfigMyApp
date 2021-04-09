#!/bin/bash

source ./modules/rbac/restui_auth.sh
source ./modules/common/http_check.sh # func_check_http_status
source ./modules/rbac/restui_license_rules.sh # func_restui_create_license_rules

_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}
_proxy_details=${3} 
_application_name=${4}
_debug=${5}

_arg_rbac_license_rule_name=${6}

echo "| Create auth header and cookie."

_token_header=$(func_restui_get_cookie "${_controller_url}" "${_user_credentials}" "${_proxy_details}")

# todo debug mode?
#if [ _debug = true ]; then echo "appd token value is: ${_token_header}"; fi

echo "| Creating license rule."
# create role
_create_license_rule_response=$(func_restui_create_license_rules "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_application_name}" "${_debug}" "${_token_header}" "${_arg_rbac_license_rule_name}")

echo "${_create_license_rule_response}"

echo "Done"
