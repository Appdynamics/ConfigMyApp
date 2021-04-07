#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/files_handling.sh # func_copy_file_and_replace_values

_controller_url=${1}   # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_application_name=${3}
_proxy_details=${4}

_include_database=${5}
_database_name=${6}

_include_sim=${7}

_enable_branding=${8}
_image_background_path=${9}
_image_logo_path=${10}

_debug=${11}

# init Dashboard templates
vanilla_noDB="./dashboards/DefaultDashboard_noDB_vanilla.json"
vanilla="./dashboards/DefaultDashboard_vanilla.json"

vanilla_noSIM="./dashboards/DefaultDashboard_noSIM_vanilla.json"
vanilla_noDB_noSIM="./dashboards/DefaultDashboard_noDB_noSIM_vanilla.json"

# init Dashboard template placeholder
templateAppName="ChangeApplicationName"
templateDBName="ChangeDBName"
templateBackgroundImageName="ChangeImageUrlBackground"
templatLogoImageName="ChangeImageUrlLogo"

endpoint="/CustomDashboardImportExportServlet"

tempFolder="temp"

dt=$(date '+%Y-%m-%d_%H-%M-%S')

endpoint="/CustomDashboardImportExportServlet"

# Dashboard
echo "Applying Database and SIM settings to the dashboard template..."
sleep 1
if [ "${_include_database}" = false ]; then

    if [ "${_include_sim}" = true ]; then
        templateFile="$vanilla_noDB"
    else
        templateFile="$vanilla_noDB_noSIM"
    fi
else
    if [ "${_include_sim}" = true ]; then
        templateFile="$vanilla"
    else
        templateFile="$vanilla_noSIM"
    fi
fi

echo -e "Done.\n"

# check if images are configured, and add default if not
if [ "$_enable_branding" = "true" ]; then
    if [ -z "${_image_background_path}" ]; then
        _image_background_path=$(func_find_file_by_name "background")
    fi

    if [ -z "${_image_logo_path}" ]; then
        _image_logo_path=$(func_find_file_by_name "logo")
    fi
fi

pathToDashboardFile=$(func_copy_file_and_replace_values ${templateFile} ${tempFolder} ${_image_background_path} ${_image_logo_path} ${_application_name} ${_database_name} )

echo "Creating dashboard in the controller"
sleep 1

dashboard_url=${_controller_url}${endpoint}

if [ $_debug = true ]; then
    echo "curl -s -X POST --user ${_user_credentials} ${dashboard_url} -F file=@${pathToDashboardFile} ${_proxy_details}"
    response=$(curl -v -X POST --user ${_user_credentials} ${dashboard_url} -F file=@${pathToDashboardFile} ${_proxy_details})
else 
    response=$(curl -s -X POST --user ${_user_credentials} ${dashboard_url} -F file=@${pathToDashboardFile} ${_proxy_details})    
fi

expected_response='"success":true'

func_check_http_response "\{$response}" $expected_response

echo "*********************************************************************"
echo "The dashboard was created successfully. "
echo "Please check the $_controller_url controller "
echo "The Dashboard name is '$_application_name:App Visibility Pane' "
echo "*********************************************************************"

# save used uploaded files
mkdir -p ./dashboards/uploaded

cp -rf "./${tempFolder}" "./dashboards/uploaded/${_application_name}"."${dt}"

func_cleanup "./${tempFolder}"
