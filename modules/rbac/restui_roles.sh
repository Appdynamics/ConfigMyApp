#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh #func_get_application_id

function func_restui_get_roles() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _application_name=${4}
    local _debug=${5}

    local X_CSRF_TOKEN_HEADER=${6}

    if [[ _debug = true ]]; then echo ">> func_restui_get_roles"; fi

    _endpoint_url="/restui/accountRoleAdministrationUiService/accountRoleSummaries"
    _method="GET"

    roleSummaries=$(curl -v -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -X ${_method} "${_controller_url}${_endpoint_url}")
    
    echo "${roleSummaries}"
}

function func_restui_create_role_with_default_view_and_view_edit_app_permissions() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _application_name=${4}
    local _debug=${5}

    local X_CSRF_TOKEN_HEADER=${6}

    local _role_name=${7}
    local _role_description=${8}

    echo "||Creating role '${_role_name}'..."

    #if [[ _debug = true ]]; then echo ">> func_restui_create_role_with_default_view_and_view_edit_app_permissions"; fi

    dt=$(date '+%Y-%m-%d_%H-%M-%S')

    _application_id_placeholder="<app-id-goes-here>"
    _overall_permissions_placeholder="<overall-permissions-go-here>"
    _application_permissions_placeholder="<application-permissions-go-here>"
    _role_name_placeholder="<role-name-goes-here>"
    _role_description_placeholder="<role-description-goes-here>"

    _files_directory="./rbac/restui_role_files"

    _application_permissions_path="${_files_directory}/permissions_view_edit_app.json"
    _overall_permissions_path="${_files_directory}/permissions_view.json"
    _permissions_base_path="${_files_directory}/permissions_base.json"

    _uploaded_path="${_files_directory}/uploaded"

    _payload_path="${_uploaded_path}/payload-${dt}.json"
    _payload_header="Content-Type: application/json; charset=utf8"

    application_permission_final="${_uploaded_path}/tmp-permissions_view_edit_app.json-${dt}"

    # get application id
    _app_id=$(func_get_application_id "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}")

    # prepare payload
    for _json_file in ${_application_permissions_path}; do

        _file_name="$(basename -- $_json_file)"
        
        echo -e "Processing '${_file_name}' json file, setting permissions for '${_application_name}' application."

        # replacing application id
        if grep -q $_application_id_placeholder ${_json_file}; then
            sed -e "s/${_application_id_placeholder}/${_app_id}/g" "${_json_file}" > "${application_permission_final}"
        else
            echo -e "WARNING Placeholder value '$_application_id_placeholder' not found in '${_file_name}'. "
        fi
    done 
    
    for _json_file in ${_permissions_base_path}; do

        _file_name="$(basename -- $_json_file)"

        _updated_file_path="${_uploaded_path}/tmp-${_file_name}-${dt}"
        _tmp_updated_file_path="${_uploaded_path}/tmp-edited-${_file_name}-${dt}"

        echo -e "Processing '${_file_name}' json file, setting global permissions."

        # set overall permissions
        if grep -q $_overall_permissions_placeholder ${_json_file}; then
            # replace newline with space
            value=$(sed -e ':a' -e 'N;$!ba' -e 's/\n/ /g' ${_overall_permissions_path})
            sed -e "s/${_overall_permissions_placeholder}/${value}/g" "${_json_file}" > "${_tmp_updated_file_path}"
        else
            echo -e "WARNING Placeholder value '$_overall_permissions_placeholder' not found in '${_file_name}'. "
        fi

        # set application-specific permissions
        if grep -q $_application_permissions_placeholder ${_tmp_updated_file_path}; then
            # replace newline with space
            value=$(sed -e ':a' -e 'N;$!ba' -e 's/\n/ /g' ${application_permission_final})
            sed -e "s/${_application_permissions_placeholder}/${value}/" "${_tmp_updated_file_path}" > "${_updated_file_path}"
        else
            echo -e "WARNING Placeholder value '$_application_permissions_placeholder' not found in '${_file_name}'. "
        fi

    done

    # replace role name and description
    sed -e "s/${_role_name_placeholder}/${_role_name}/g" -e "s/${_role_description_placeholder}/${_role_description}/g" "${_updated_file_path}" > "${_payload_path}"

    _endpoint_url="/restui/accountRoleAdministrationUiService/accountRoles/create"
    _method="POST"

    response=$(curl -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -H "${_payload_header}" -X ${_method} --data "@${_payload_path}" "${_controller_url}${_endpoint_url}")

    # remove temporary files, save only final payload backup
    rm ${_uploaded_path}/tmp-*

    echo "${response}"

}


