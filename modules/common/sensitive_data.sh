#!/bin/bash

#source ./modules/common/logging.sh # func_log_error_to_file

# can be called form any part of the program => handle varaibles here
if ([ -z "${_arg_data_masking// }" ] && [ ! -z "${CMA_DATA_MASKING// }" ]); then
    _arg_data_masking=${CMA_DATA_MASKING}
fi

if ([ -z "${_arg_data_masking_patterns// }" ] && [ ! -z "${CMA_DATA_MASKING_PATTERNS// }" ]); then
    _arg_data_masking_patterns=${CMA_DATA_MASKING_PATTERNS}
fi

if ([ -z "${_arg_data_masking_strategy// }" ] && [ ! -z "${CMA_DATA_MASKING_STRATEGY// }" ]); then
    _arg_data_masking_strategy=${CMA_DATA_MASKING_STRATEGY}
fi

conf_file="config.json"

if [[ -z "${_arg_data_masking// }" ]]; then
    _arg_data_masking=$(jq -r '.sensitive_data[].data_masking' <${conf_file})
fi
if [[ -z "${_arg_data_masking_patterns// }" ]]; then
    _arg_data_masking_patterns=$(jq -r '.sensitive_data[].data_masking_patterns' <${conf_file})
fi
if [[ -z "${_arg_data_masking_strategy// }" ]]; then
    _arg_data_masking_strategy=$(jq -r '.sensitive_data[].data_masking_strategy' <${conf_file})
fi

## check if values are valid data type
if ([ ! $_arg_data_masking = false ] && [ ! $_arg_data_masking = true ] ); then 
    echo -n "Data-masking value \"${_arg_data_masking}\" not recognized. Proceeding with data not being masked..."
fi

# source ./modules/common/sensitive_data.sh; func_data_masking "me.saas.com:443" "saas" "exact"
function func_data_masking(){
    local message="$1"
    local patterns="$2" #todo no characters: comma, # or * allowed
    local strategy="$3" # valid: exact, before, after

    # argumebts from configuration
    if [ $_arg_data_masking = false ]; then
        echo "$message"
        exit 0
    fi

    if [[ -z "$patterns" ]]; then
        patterns=${_arg_data_masking_patterns}
    fi

    if [[ -z "$strategy" ]]; then
        strategy=${_arg_data_masking_strategy}
    fi

    masking_string="*********"
    valid_data_masking_strategies=("exact" "before" "after") 
    
    if [[ ! " ${valid_data_masking_strategies[@]} " =~ " ${strategy} " ]]; then
        # whatever you want to do when array doesn't contain value
        echo -e "[Data masking strategy \"${strategy}\" not recognized] "
    fi

    for pattern in ${patterns//,/ }
    do
        # mask sensitive info
        case $strategy in
            exact)
                message=$(echo $message | sed -e "s#${pattern}#${masking_string}#g")
                ;;
            before)
                message=$(echo $message | sed -e "s#.*${pattern}#${masking_string}#g")
                ;;
            after)
                message=$(echo $message | sed -e "s#${pattern}.*'#${masking_string}#g")
                ;;
            *)
                # echo -n "Message not masked..."
                ;;
            esac

    done

    echo "$message"
}