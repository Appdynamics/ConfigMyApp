#!/bin/bash

function func_restui_get_cookie() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    response=$(curl -i -s -c cookie.appd --user ${_user_credentials} -X GET ${_controller_url}/auth?action=login ${_proxy_details})
    X_CSRF_TOKEN="$(grep X-CSRF-TOKEN cookie.appd|rev|cut -d$'\t' -f1|rev)"
    X_CSRF_TOKEN_HEADER="`if [ -n "$X_CSRF_TOKEN" ]; then echo "X-CSRF-TOKEN:$X_CSRF_TOKEN"; else echo ''; fi`"

    echo "${X_CSRF_TOKEN_HEADER}" # echo header value only (to be used by other functions)
}

