#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status, func_check_http_response

_controller_url=${1}   # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_application_name=${3}
_proxy_details=${4}
_debug=${5}

_custom_dash_dir="./custom_dashboards" #I might move this into dashboard folder.. let see..
_temp_dash_dir="$_custom_dash_dir/temp"

templateAppName="ChangeApplicationName"
_dasboard_API_endpoint="CustomDashboardImportExportServlet"

dt=$(date '+%Y-%m-%d_%H-%M-%S')

# check if custom dashboard files exist
if [ "$(ls -A $_custom_dash_dir/*.json)" ]; then
    echo "Found custom JSON file(s) in $_custom_dash_dir"
    #ls -l $_custom_dash_dir/*.json
else
    echo "$_custom_dash_dir directory is empty. "
    echo "Please add custom dashboard JSON files to the $_custom_dash_dir directory. "
    echo "Aborting..."
    exit 1
fi

mkdir -p "$_temp_dash_dir" && cp -r "$_custom_dash_dir"/*.json "$_temp_dash_dir"

for _dash_file in $_temp_dash_dir/*.json; do

    _file_name="$(basename -- $_dash_file)"
    
    echo -e "Processing ${_file_name} dashboard template. Using the '${_application_name}' application. \n"

    if grep -q $templateAppName ${_dash_file}; then
        sed -i -e "s/${templateAppName}/${_application_name}/g" "${_dash_file}"
    else
        echo -e "WARNING Placeholder value '$templateAppName' not found in json file provided. Application name not replaced. "
        echo -e "        Refer to the documentation for more details: https://appdynamics.github.io/ConfigMyApp/usecases/8-custom_dashboards.html \n"
        #exit 1
    fi

    sleep 1 # let it cool off
    
    echo "Uploading '${_file_name}' custom dashboard..." #$_dash_file to ${_controller_url}... "

    if [ $_debug = true ]; then
        output="-v"
    else
        output="-s"
    fi

    response=$(curl ${output} -X POST --user ${_user_credentials} ${_controller_url}/${_dasboard_API_endpoint} -F file=@${_dash_file} ${_proxy_details})

    expected_response='"success":true'

    func_check_http_response "\{$response}" $expected_response
    
    # save used uploaded files
    mkdir -p "${_custom_dash_dir}/uploaded"

    cp -rf "${_dash_file}" "${_custom_dash_dir}/uploaded/${_application_name}"-"${dt}.json"

    #clean up - one at a time - to avoid re-processing
    rm -rf "${_dash_file}"

done
