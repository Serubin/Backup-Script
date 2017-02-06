#!/bin/bash

# $1 - method
# $2 - url
# $3 - post, json
on_curl(){
    
    POST=""
    if [[ "${3}" != "" ]]; then
        POST="-d \"${3}\""
    fi

    echo ${3} | curl -X ${1} \
        -H "Authorization: Bearer ${online_auth_token}" \
        -H "Content-Type: application/json" \
        -H "X-Pretty-JSON: 1" \
        $([[ "${3}" != "" ]] && echo "-d @-") \
        https://api.online.net/api/v1${2}
}


