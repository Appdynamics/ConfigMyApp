#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh # func_get_application_id

# 1. INPUT PARAMETERS
_controller_url=${1}   # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_application_name=${3}
_proxy_details=${4}

_health_rules_delete=${5}

_debug=${6}

function func_delete_health_rules(){
    local appId=$1
    local healthRulesToDelete="$2"

     # get all current health rules for application
    allHealthRules=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules ${_proxy_details})

    if [ $_debug = true ]; then
        echo "curl -s --user ${_user_credentials} '${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules' ${_proxy_details}"
    fi
    
    echo $healthRulesToDelete | sed -n 1'p' | tr ',' '\n' | while read hrName; do
        echo "Deleting '$hrName' health rule..."

        # get health rule id (if exists)
        healthRuleId=$(jq --arg hrName "$hrName" '.[] | select(.name == $hrName) | .id' <<<$allHealthRules)

        # delete if health rule exists
        if [ ! -z "${healthRuleId// }" ]; then
            httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules/${healthRuleId} ${_proxy_details})
            func_check_http_status $httpCode "Error occured while deleting health rule '${hrName}'."
            echo "Done."
        else 
            echo "Health rule '$hrName' not found. No action performed."
        fi
        
    done
}

# # 3. PREPARE 
# # check if App exist
# allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON $_proxy_details)

# applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

# if [ "$applicationObject" = "" ]; then
#     func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
# fi

# appId=$(jq '.id' <<<$applicationObject)
appId=$(func_get_application_id "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}")

#All conditions met..

# 4. EXECUTE 
func_delete_health_rules "${appId}" "${_health_rules_delete}"