#!/bin/bash
# Match types: MATCHES_REGEX, CONTAINS, EQUALS, STARTS_WITH, ENDS_WITH, IS_IN_LIST, IS_NOT_EMPTY
# The format of the JSON must be maintained at all times.. all four sections must be available even if you're not using them, leave them blank.

bt_folder="./bt_api_templates"
bt_conf="./bt_config/configBT.json"
bt_config_template="bt_config_template.xml"
app_name="$1"
user_credentials="$2"
controller_url="$3"


poco_temp_file="poco_temp_file.xml"
poco_scope_temp_file="poco_scope_temp_file.xml"

servlet_temp_file="servlet_temp_file.xml"
servlet_scope_temp_file="servlet_scope_temp_file.xml"

pojo_scope_temp_file="pojo_scope_temp_file.xml"
pojo_temp_file="pojo_temp_file.xml"

asp_scope_temp_file="asp_scope_temp_file.xml"
asp_temp_file="asp_temp_file.xml"

#SED variables
template_rule_name="template_bt_rule_name"
template_class_name="template_bt_class_name"
template_method_name="template_bt_method_name"
template_priority="template_bt_priority"
template_desc="template_bt_description"
template_class_match_condition="template_class_match_condition"
template_method_match_condition="template_method_match_condition"

template_http_matching_condition="template_http_match_condition"
template_http_matching_strings="template_http_match_strings"
template_include_or_exclude="template_include_or_exclude"

scopes='<rule rule-description="template_bt_description" rule-name="template_bt_rule_name"/>'

java_pojo_tx_rule='<rule agent-type="APPLICATION_SERVER" enabled="true"
            priority="template_bt_priority" rule-description="template_bt_description" rule-name="template_bt_rule_name"
            rule-type="TX_MATCH_RULE" version="1">
            <tx-match-rule>{"type":"CUSTOM","txcustomrule":{"type":"template_include_or_exclude","txentrypointtype":"POJO","matchconditions":
                [{"type":"INSTRUMENTATION_PROBE","instrumentionprobe":{"javadefinition":{"classmatch":{"type":"MATCHES_CLASS",
                "classnamecondition":{"type":"template_class_match_condition","matchstrings":["template_bt_class_name"]}},
                "methodmatch":{"methodnamecondition":{"type":"template_method_match_condition","matchstrings":["template_bt_method_name"]}},
                "methodparamtypes":[]}}}],"actions":[],"properties":[{"type":"BOOLEAN","name":"POJO_BACKUP","booleanvalue":false,
                "ranges":[]}]},"agenttype":"APPLICATION_SERVER"}
            </tx-match-rule>
        </rule>'

dotnet_poco_tx_rule='<rule agent-type="DOT_NET_APPLICATION_SERVER" enabled="true"
            priority="template_bt_priority" rule-description="template_bt_description" rule-name="template_bt_rule_name"
            rule-type="TX_MATCH_RULE" version="1">
            <tx-match-rule>{"type":"CUSTOM","txautodiscoveryrule":{"autodiscoveryconfigs":[]},
                "txcustomrule":{"type":"template_include_or_exclude","txentrypointtype":"POCO","matchconditions":
                [{"type":"INSTRUMENTATION_PROBE","instrumentionprobe":{"javadefinition":
                {"classmatch":{"type":"MATCHES_CLASS","classnamecondition":
                {"type":"template_class_match_condition","matchstrings":["template_bt_class_name"]}},
                "methodmatch":{"methodnamecondition":{"type":"template_method_match_condition","matchstrings":["template_bt_method_name"]}},
                "methodparamtypes":[]}}}],"actions":[],"properties":[{"type":"BOOLEAN","name":"POJO_BACKUP",
                "booleanvalue":false,"ranges":[]}]},"agenttype":"DOT_NET_APPLICATION_SERVER"}
            </tx-match-rule>
        </rule>'

servlet_tx_rule='<rule agent-type="APPLICATION_SERVER" enabled="true"
            priority="template_bt_priority" rule-description="template_bt_description" rule-name="template_bt_rule_name"
            rule-type="TX_MATCH_RULE" version="1">
            <tx-match-rule>{"type":"CUSTOM","txautodiscoveryrule":{"autodiscoveryconfigs":[]},
            "txcustomrule":{"type":"template_include_or_exclude","txentrypointtype":"SERVLET","matchconditions":
            [{"type":"HTTP","httpmatch":{"uri":{"type":"template_http_match_condition","matchstrings":["template_http_match_strings"]},
            "parameters":[],"headers":[],"cookies":[]}}],"actions":[],"properties":[]},
            "agenttype":"APPLICATION_SERVER"}</tx-match-rule>
        </rule>'

asp_tx_rule='<rule agent-type="DOT_NET_APPLICATION_SERVER" enabled="true"
            priority="template_bt_priority" rule-description="template_bt_description"
            rule-name="template_bt_rule_name" rule-type="TX_MATCH_RULE" version="1">
            <tx-match-rule>{"type":"CUSTOM","txautodiscoveryrule":{"autodiscoveryconfigs":[]},
            "txcustomrule":{"type":"template_include_or_exclude","txentrypointtype":"ASP_DOTNET","matchconditions":
            [{"type":"HTTP","httpmatch":{"uri":{"type":"template_http_match_condition","matchstrings":["template_http_match_strings"]},
            "parameters":[],"headers":[],"cookies":[]}}],"actions":[],"properties":[]},
            "agenttype":"DOT_NET_APPLICATION_SERVER"}</tx-match-rule>
        </rule>'

java_servlet_func() {
    #these variables need to be global variables as the func is returning multiple values
    servlet_custom_rules=""
    servlet_scopes=""

    for row in $(cat "${bt_conf}" | envsubst "${variable_whitelist}" | jq -r ' .java_servlet_rules[]? | @base64'); do

        _ijq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        local rule_name=$(_ijq '.rule_name')
        local priority=$(_ijq '.priority')
        local http_matching_condition=$(_ijq '.matching_condition')
        local http_matching_strings=$(_ijq '.matching_strings')
        local include_or_exclude_rule=$(_ijq '.include_or_exclude_rule')
        #the exclude type must be in CAPS otherwise, the API will spit out a 500 internal error
        local include_or_exclude_rule=$(echo "$include_or_exclude_rule" | awk '{print toupper($0)}')

        if [ -z "$include_or_exclude_rule" ] || [ "$include_or_exclude_rule" = "NULL" ] || [ "$include_or_exclude_rule" = "" ]; then
            local include_or_exclude_rule="INCLUDE"
        fi

        if [ -z "$priority" ] || [ "$priority" = "null" ] || [ "$priority" = "" ]; then
            local priority="0"
        fi
        local desc="$rule_name :Created on $(date) by ConfigMyApp"

        echo "Processing - ${rule_name} => ${http_matching_condition}.${http_matching_strings}. Matching condition "
        echo ""
        #not using / with sed as URLs may contain /, using ~ instead.
        local rule_handler=$(echo $servlet_tx_rule | sed "s~${template_rule_name}~${rule_name}~g; s~${template_priority}~${priority}~g; s~${template_desc}~${desc}~g; s~${template_http_matching_condition}~${http_matching_condition}~g; s~${template_http_matching_strings}~${http_matching_strings}~g; s~${template_include_or_exclude}~${include_or_exclude_rule}~g")
        servlet_custom_rules+="         <!-- $http_match_strings.$rule_name -->"$'\n'"        $rule_handler"$'\n'
        local scope_handler=$(echo $scopes | sed "s~${template_rule_name}~${rule_name}~g; s~${template_desc}~${desc}~g")
        servlet_scopes+="        $scope_handler"$'\n'
    done

    echo "$servlet_custom_rules" >"$bt_folder/$servlet_temp_file"
    echo "$servlet_scopes" >"$bt_folder/$servlet_scope_temp_file"
    sed -i.bak -e "/<!--SERVLET-PLACEHOLDER-->/r $bt_folder/$servlet_temp_file" -e "//d" "$bt_file_path"
    sed -i.bak -e "/<!--SERVLET-SCOPE-PLACEHOLDER-->/r $bt_folder/$servlet_scope_temp_file" -e "//d" "$bt_file_path"
}

asp_func() {
    #these variables need to be global variables as the func is returning multiple values
    asp_custom_rules=""
    asp_scopes=""
    for row in $(cat "${bt_conf}" | envsubst "${variable_whitelist}" | jq -r ' .dotnet_asp_rules[]? | @base64'); do

        _ijq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }
        local rule_name=$(_ijq '.rule_name')
        local priority=$(_ijq '.priority')
        local http_matching_condition=$(_ijq '.matching_condition')
        local http_matching_strings=$(_ijq '.matching_strings')
        local include_or_exclude_rule=$(_ijq '.include_or_exclude_rule')
        #the exclude type must be in CAPS otherwise, the API will spit out a 500 internal error
        local include_or_exclude_rule=$(echo "$include_or_exclude_rule" | awk '{print toupper($0)}')

        if [ -z "$include_or_exclude_rule" ] || [ "$include_or_exclude_rule" = "NULL" ] || [ "$include_or_exclude_rule" = "" ]; then
            local include_or_exclude_rule="INCLUDE"
        fi

        if [ -z "$priority" ] || [ "$priority" = "null" ] || [ "$priority" = "" ]; then
            local priority="0"
        fi

        local desc="$rule_name :Created on $(date) by ConfigMyApp"

        echo "Processing - ${rule_name} => ${http_matching_condition}.${http_matching_strings}. Matching condition "
        echo ""

        local rule_handler=$(echo $asp_tx_rule | sed "s~${template_rule_name}~${rule_name}~g; s~${template_priority}~${priority}~g; s~${template_desc}~${desc}~g; s~${template_http_matching_condition}~${http_matching_condition}~g; s~${template_http_matching_strings}~${http_matching_strings}~g; s~${template_include_or_exclude}~${include_or_exclude_rule}~g")
        asp_custom_rules+="         <!-- $http_match_strings.$rule_name -->"$'\n'"        $rule_handler"$'\n'
        local scope_handler=$(echo $scopes | sed "s~${template_rule_name}~${rule_name}~g; s~${template_desc}~${desc}~g")
        asp_scopes+="        $scope_handler"$'\n'
    done

    echo "$asp_custom_rules" >"$bt_folder/$asp_temp_file"
    echo "$asp_scopes" >"$bt_folder/$asp_scope_temp_file"

    sed -i.bak -e "/<!--ASP-PLACEHOLDER-->/r $bt_folder/$asp_temp_file" -e "//d" "$bt_file_path"
    sed -i.bak -e "/<!--ASP-SCOPE-PLACEHOLDER-->/r $bt_folder/$asp_scope_temp_file" -e "//d" "$bt_file_path"

}

dotnet_poco_func() {
    #these variables need to be global variables as the func is returning multiple values
    dotnet_poco_custom_rules=""
    dotnet_poco_scopes=""
    for row in $(cat "${bt_conf}" | envsubst "${variable_whitelist}" | jq -r ' .dotnet_poco_rules[]? | @base64'); do

        _ijq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        local class_name=$(_ijq '.class_name')
        local method_name=$(_ijq '.method_name')
        local rule_name=$(_ijq '.rule_name')
        local priority=$(_ijq '.priority')
        local class_match_condition=$(_ijq '.class_matching_condition')
        local method_match_condition=$(_ijq '.method_matching_condition')
        local include_or_exclude_rule=$(_ijq '.include_or_exclude_rule')
        #the exclude type must be in CAPS otherwise, the API will spit out a 500 internal error
        local include_or_exclude_rule=$(echo "$include_or_exclude_rule" | awk '{print toupper($0)}')

        if [ -z "$include_or_exclude_rule" ] || [ "$include_or_exclude_rule" = "NULL" ] || [ "$include_or_exclude_rule" = "" ]; then
            local include_or_exclude_rule="INCLUDE"
        fi

        if [ -z "$priority" ] || [ "$priority" = "null" ] || [ "$priority" = "" ]; then
            local priority="0"
        fi

        local desc="$rule_name :Created on $(date) by ConfigMyApp"

        echo "Processing - ${rule_name} => ${class_name}.${method_name}. With ${class_match_condition} class match condition "
        echo ""

        local rule_handler=$(echo $dotnet_poco_tx_rule | sed "s/${template_rule_name}/${rule_name}/g; s/${template_method_name}/${method_name}/g; s/${template_priority}/${priority}/g; s/${template_class_name}/${class_name}/g; s/${template_desc}/${desc}/g; s/${template_class_match_condition}/${class_match_condition}/g; s/${template_method_match_condition}/${method_match_condition}/g; s~${template_include_or_exclude}~${include_or_exclude_rule}~g")
        dotnet_poco_custom_rules+="         <!-- $class_name.$rule_name -->"$'\n'"        $rule_handler"$'\n'
        local scope_handler=$(echo $scopes | sed "s/${template_rule_name}/${rule_name}/g; s/${template_desc}/${desc}/g")
        dotnet_poco_scopes+="        $scope_handler"$'\n'
    done

    #Create .Net POCO temp file
    echo "$dotnet_poco_custom_rules" >"$bt_folder/$poco_temp_file"
    echo "$dotnet_poco_scopes" >"$bt_folder/$poco_scope_temp_file"

    sed -i.bak -e "/<!--POCO-PLACEHOLDER-->/r $bt_folder/$poco_temp_file" -e "//d" "$bt_file_path"
    sed -i.bak -e "/<!--POOCO-SCOPE-PLACEHOLDER-->/r $bt_folder/$poco_scope_temp_file" -e "//d" "$bt_file_path"
}

java_pojo_func() {
    java_pojo_custom_rules=""
    java_pojo_scopes=""
    for row in $(cat "${bt_conf}" | envsubst "${variable_whitelist}" | jq -r ' .java_pojo_rules[]? | @base64'); do

        _ijq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        local class_name=$(_ijq '.class_name')
        local method_name=$(_ijq '.method_name')
        local rule_name=$(_ijq '.rule_name')
        local priority=$(_ijq '.priority')
        local class_match_condition=$(_ijq '.class_matching_condition')
        local method_match_condition=$(_ijq '.method_matching_condition')
        local desc="$rule_name :Created on $(date) by ConfigMyApp"
        local include_or_exclude_rule=$(_ijq '.include_or_exclude_rule')
        #the exclude type must be in CAPS otherwise, the API will spit out a 500 internal error
        local include_or_exclude_rule=$(echo "$include_or_exclude_rule" | awk '{print toupper($0)}')

        if [ -z "$include_or_exclude_rule" ] || [ "$include_or_exclude_rule" = "NULL" ] || [ "$include_or_exclude_rule" = "" ]; then
            local include_or_exclude_rule="INCLUDE"
        fi

        if [ -z "$priority" ] || [ "$priority" = "null" ] || [ "$priority" = "" ]; then
            local priority="0"
        fi

        echo "Processing - ${rule_name} => ${class_name}.${method_name}. With ${class_match_condition} class match condition "
        echo ""

        local rule_handler=$(echo $java_pojo_tx_rule | sed "s/${template_rule_name}/${rule_name}/g; s/${template_method_name}/${method_name}/g; s/${template_priority}/${priority}/g; s/${template_class_name}/${class_name}/g; s/${template_desc}/${desc}/g; s/${template_class_match_condition}/${class_match_condition}/g; s/${template_method_match_condition}/${method_match_condition}/g; s~${template_include_or_exclude}~${include_or_exclude_rule}~g")
        java_pojo_custom_rules+="        <!-- $class_name.$rule_name -->"$'\n'"        $rule_handler"$'\n'
        local scope_handler=$(echo $scopes | sed "s/${template_rule_name}/${rule_name}/g; s/${template_desc}/${desc}/g")
        java_pojo_scopes+="        $scope_handler"$'\n'
    done

    #Create Java POJO temp file
    echo "$java_pojo_custom_rules" >"$bt_folder/$pojo_temp_file"
    echo "$java_pojo_scopes" >"$bt_folder/$pojo_scope_temp_file"

    sed -i.bak -e "/<!--POJO-PLACEHOLDER-->/r $bt_folder/$pojo_temp_file" -e "//d" "$bt_file_path"

    sed -i.bak -e "/<!--POJO-SCOPE-PLACEHOLDER-->/r $bt_folder/$pojo_scope_temp_file" -e "//d" "$bt_file_path"
}

dt=$(date '+%Y-%m-%d_%H-%M-%S')

bt_file_path="$bt_folder/$app_name-$dt.xml"

cp "$bt_folder/$bt_config_template" "$bt_file_path"

# Whitelist variables with prefix "CMA_VAR"
variable_whitelist="$(printf '${%s} ' ${!CMA_VAR*})"
echo -e "The following variables will be used for substitution: ${variable_whitelist}\n"

#echo $variable_whitelist

#Call ASP function
asp_func

#Call Servlet function
java_servlet_func

#Call the POCO function
dotnet_poco_func

#Call the POJO  function
java_pojo_func

#delete the temp files
sleep 1

rm $bt_folder/*temp_file.xml
rm $bt_folder/*.bak

if [ -f "$bt_file_path" ]; then
    echo "The business transaction detection rule file has been generated"
    echo ""
    echo "The file path is $bt_file_path"
    sleep 1
    echo ""
    echo "Please wait while we configure BT detection rules in $appName"

    btendpoint="/transactiondetection/${app_name}/custom"

    if [ -z "${controller_url// }" ]; then
        echo "Controller host is not set, assume dry run:"
        echo "curl -s -X POST -w \"%{http_code}\" --user ${user_credentials} controller${btendpoint} -F file=@${bt_file_path} ${proxy_details})"
    else
        bt_response=$(curl -s -X POST -w "%{http_code}" --user ${user_credentials} ${controller_url}${btendpoint} -F file=@${bt_file_path} ${proxy_details})

        if [[ "$bt_response" == *"200"* ]]; then
            echo ""
            echo "*********************************************************************"
            echo "ConfigMyApp created Business transaction detection rules successfully."
            echo "Please check $appName detection rule configuration pages."
            echo "*********************************************************************"
            echo ""
        else
            msg="An Error occured whilst creating business transaction detection rules. Please refer to the error.log file for further details"
            echo "${dt} An Error occured whilst creating business transaction detection rules." >> error.log
            echo "${dt} ERROR $bt_response" >>error.log
            echo "$msg"
            echo "$bt_response"
            echo ""
            sleep 1
        fi
        #clean up
        mkdir -p $bt_folder/uploaded
        mv $bt_file_path $bt_folder/uploaded
    fi

else
    echo "$bt_file_path does not exist"
    echo ""
    echo "Business transactions will not be configured"
    echo ""
fi
