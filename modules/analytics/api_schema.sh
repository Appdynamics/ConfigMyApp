source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh # func_get_application_id

# CRUD API interface for Analytics ADQL and Custom Metrics
# https://jira.corp.appdynamics.com/browse/IDEA-1454

key_name="Alex-xxx-Key"
analytics_api_key="4569d30e-xxx-1bd803037382"
global_account_name="customer1_b58cd801-xxx-b843615f3f7a"
analytics_url="fra-ana-api.saas.appdynamics.com"
analytics_port="9080"

function func_get_all_schemas() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    endpoint_url="/events/schema/myProducts"
    method="GET"
    if [[ _debug = true ]]; then _output="-v"; else _output="-s"; fi

    account_header="X-Events-API-AccountName:${global_account_name}" 
    api_key_header="X-Events-API-Key:${analytics_api_key}"
    content_type_header="Content-type: application/vnd.appd.events+json;v=2"

    payload='{"schema" : { "id": "string", "productBrand": "string", "userRating": "integer", "price": "float", "productName": "string", "description": "string" } }'

    result=$(curl -v -X POST "https://${analytics_url}:${analytics_port}/${endpoint_url}" -H"${account_header}" -H"${api_key_header}" -H"${content_type_header}" -d ${payload})

    echo "${result}"

}