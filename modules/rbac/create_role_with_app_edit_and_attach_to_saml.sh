#!/bin/bash

source ./modules/rbac/api_roles.sh 
source ./modules/rbac/api_users.sh
source ./modules/rbac/api_groups.sh

source ./modules/rbac/restui_auth.sh
source ./modules/rbac/restui_roles.sh
source ./modules/rbac/restui_saml.sh

source ./modules/common/http_check.sh # func_check_http_status

_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}
_proxy_details=${3} 
_application_name=${4}
_debug=${5}

_role_name=${6}
_role_description=${7}

_saml_group_name=${8}

if [ -z "${_role_name// }" ]; then
    func_check_http_status 404 "Role name not provided. Unable to create it without this value."
    exit 1
fi

echo "| Create auth header and cookie."

_token_header=$(func_restui_get_cookie "${_controller_url}" "${_user_credentials}" "${_proxy_details}")

if [ _debug = true ]; then echo "appd token value is: ${_token_header}"; fi

echo "| Create role '${_role_name}' with application permissions."
# create role
_role_with_permissions_response=$(func_restui_create_role_with_default_view_and_view_edit_app_permissions "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_application_name}" "${_debug}" "${_token_header}" "${_role_name}" "${_role_description}")

sleep 5 # creating role takes some time, wait before going to fetch it

echo "| Check if role created successfully."
_expected_response='"id" :' # returns id with space before : on success
func_check_http_response "\{$_role_with_permissions_response}" "${_expected_response}"

echo "| Get role by id."
# get created role by name
_get_role_response=$(func_get_role_by_name "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_application_name}" "${_debug}" "${_role_name}")

_expected_response='"id":' # returns id on success
func_check_http_response "\{$_get_role_response}" "${_expected_response}"

# get role ID from response
_role_id=$(jq -r  '.id' <<< $_get_role_response)

sleep 1

# role ids have to be existing ones for saml update to be successfully performed (although 200 is returned in any case)
# Note: when multiple: e.g. role_ids="28,16" - no space!
if [ -z "${_role_id// }" ]; then
    func_check_http_status 404 "Role '${_role_name}' ID not found. Unable to add its identifier to SAML group."
    exit 1
fi

## SAML group
if [ -z "${_saml_group_name// }" ]; then
    func_check_http_status 404 "SAML group name cannot be empty."
    exit 1
fi

echo "| Attach role to SAML Group."
# create saml group
_saml_response=$(func_restui_update_saml_configuration "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_debug}" "${_token_header}" "${_role_id}" "${_saml_group_name}")

echo "|| Role '${_role_name}' added to SAML group '${_saml_group_name}' successfully."