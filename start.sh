#!/bin/bash
#
# do not delete this comment --> m4_ignore([

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}

warn()
{
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
}

begins_with_short_option()
{
	local first_option all_short_options='cPupadsbh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_use_encoded_credentials=false

_arg_controller_host=
_arg_controller_port=8090
_arg_use_https=false

_arg_account="customer1"
_arg_username=
_arg_password=

_arg_use_proxy=false
_arg_proxy_url=
_arg_proxy_port=

_arg_application_name=
_arg_configure_bt=false

_arg_bt_only=false

_arg_health_rules_only=false
_arg_health_rules_overwrite=true
_arg_health_rules_delete=

_arg_use_branding=true
_arg_logo_name=
_arg_background_name=

_arg_suppress_action=false
_arg_suppress_start=
_arg_suppress_duration=
_arg_suppress_upload_files=false
_arg_suppress_name=
_arg_suppress_delete=

_arg_upload_custom_dashboard=false
_arg_upload_default_dashboard=true
_arg_include_database=false
_arg_database_name=
_arg_include_sim=false

_valid_rbac_actions=("role-saml" "license-rule") # array of valid rbac actions e.g. ("role" "role-saml" "saml") 

_arg_rbac_only=false
_arg_rbac_action="role-saml" # the only action for now in rbac module is "role-saml"
_arg_rbac_role_name=
_arg_rbac_role_description=
_arg_rbac_saml_group_name=
_arg_rbac_license_rule_name=

_arg_debug=false

_arg_controller_port_explicitly_set=false
_arg_use_encoded_credentials_explicitly_set=false
_arg_use_https_explicitly_set=false
_arg_account_explicitly_set=false
_arg_use_proxy_explicitly_set=false
_arg_include_database_explicitly_set=false
_arg_include_sim_explicitly_set=false
_arg_configure_bt_explicitly_set=false
_arg_use_branding_explicitly_set=false
_arg_bt_only_explicitly_set=false
_arg_suppress_action_explicitly_set=false
_arg_suppress_upload_files_explicitly_set=false
_arg_upload_default_dashboard_explicitly_set=false
_arg_upload_custom_dashboard_explicitly_set=false
_arg_health_rules_only_explicitly_set=false
_arg_health_rules_overwrite_explicitly_set=false
_arg_rbac_only_explicitly_set=false
_arg_rbac_action_explicitly_set=false


print_help()
{
	printf '%s\n' "ConfigMyApp - Self-service configuration tool."
	#printf 'Usage: %s [-c|--controller-host <arg>] [-P|--controller-port <arg>] [-u|--username <arg>] [-p|--password <arg>] [--(no-)use-proxy] [--proxy-url <arg>] [--proxy-port <arg>] [-a|--application-name <arg>] [--(no-)include-database] [-d|--database-name <arg>] [-s|--(no-)include-sim] [-b|--(no-)configure-bt] [-h|--help]\n' "$0"
	printf '%s\n' ""
	
	printf '%s\n' "Connection options:"
	printf '\t%s\n' "-c, --controller-host: controller host (no default)"
	printf '\t%s\n' "-P, --controller-port: controller port (${_arg_controller_port} by default)"
	printf '\t%s\n' "--use-https, --no-use-https: if on, specifies that the agent should use SSL (${_arg_use_https} by default)"

	printf '%s\n' "Account options:"
	printf '\t%s\n' "--account: account help (${_arg_account} by default)"
	printf '\t%s\n' "-u, --username: AppDynamics' user username (no default)"
	printf '\t%s\n' "-p, --password: AppDynamics' user password (no default)"
	printf '\t%s\n' "--use-encoded-credentials, --no-use-encoded-credentials: use encoded credentials (${_arg_use_encoded_credentials} by default)"
	
	printf '%s\n' "Proxy options:"
	printf '\t%s\n' "--use-proxy, --no-use-proxy: use proxy optional argument (${_arg_use_proxy} by default)"
	printf '\t%s\n' "--proxy-url: proxy url (no default)"
	printf '\t%s\n' "--proxy-port: proxy port (no default)"

	printf '%s\n' "Branding options:"
	printf '\t%s\n' "--use-branding, --no-use-branding: enable branding (${_arg_use_branding} by default)"
	printf '\t%s\n' "--logo-name: logo image file name (no default)"
	printf '\t%s\n' "--background-name: background image file name (no default)"

	printf '%s\n' "Application options:"
	printf '\t%s\n' "-a, --application-name: application name (no default)"
	#todo --configure-bt flag to be depreciated
	printf '\t%s\n' "-b, --configure-bt, --no-configure-bt: configure busness transactions (${_arg_configure_bt} by default)"
	printf '\t%s\n' "--bt-only, --no-bt-only: Configure business transactions only (${_arg_bt_only} by default)"

	printf '%s\n' "Health rules options:"
	printf '\t%s\n' "--health-rules-only, --no-health-rules-only: configure health rules only (${_arg_health_rules_only} by default)"
	printf '\t%s\n' "--health-rules-overwrite, --no-health-rules-overwrite: overwrite health rules if exist (${_arg_health_rules_overwrite} by default)"
	printf '\t%s\n' "--health-rules-delete: health rule names to delete, array of strings (no default)"
	printf '\t%s\n' "-s, --include-sim, --no-include-sim: include server visibility (${_arg_include_sim} by default)"

	printf '%s\n' "Action suppression options:"
	printf '\t%s\n' "--suppress-action, --no-suppress-action: use application action suppression (${_arg_suppress_action} by default)"
	printf '\t%s\n' "--suppress-start: application suppression start date in \"yyyy-MM-ddThh:mm:ss+0000\" format (GMT) (current datetime by default)"
	printf '\t%s\n' "--suppress-duration: application suppression duration in minutes (one hour by default)"
	printf '\t%s\n' "--suppress-name: custom name of the supression action, if none specified name is auto-generated"
	
	printf '\t%s\n' "--suppress-upload-files, --no-suppress-upload-files: upload action suppression files from a folder (${_arg_suppress_upload_files} by default)"
	
	printf '\t%s\n' "--suppress-delete: delete action suppression by passing action name to this parameter (no default)"

	printf '%s\n' "Dashboard options:"
	printf '\t%s\n' "--upload-custom-dashboard, --no-upload-custom-dashboard: creates custom dashboard(s) from a file (${_arg_upload_custom_dashboard} by default)"
	printf '\t%s\n' "--upload-default-dashboard, --no-upload-default-dashboard: creates default dashboard (${_arg_upload_default_dashboard} by default)"
	printf '\t%s\n' "--include-database, --no-include-database: set true to include database (${_arg_include_database} by default)"
	printf '\t%s\n' "-d, --database-name: mandatory if --include-database set to true (no default)"
	printf '\t%s\n' "-s, --include-sim, --no-include-sim: include server visibility (${_arg_include_sim} by default)"

	printf '%s\n' "Role-Based Access Control (RBAC) options:"
	printf '\t%s\n' "--rbac-only, --no-rbac-only: configure RBAC (${_arg_rbac_only} by default)"
	printf '\t%s\n' "--rbac-action: RBAC action to be performed ('${_arg_rbac_action}' by default)"
	printf '\t%s\n' "--rbac-role-name: RBAC role name (auto-generated by default)"
	printf '\t%s\n' "--rbac-role-description: RBAC role description, not mandatory (no default)"
	printf '\t%s\n' "--rbac-saml-group-name: RBAC SAML group name (auto-generated by default)"
	printf '\t%s\n' "--rbac-license-rule-name: License rule name (auto-generated by default)"

	printf '%s\n' "Help options:"
	printf '\t%s\n' "-h, --help: Prints help"
	printf '\t%s\n' "--debug, --no-debug: Run in debug mode (${_arg_debug} by default)"
	printf '%s\n' ""
}

parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			--no-use-encoded-credentials|--use-encoded-credentials)
				_arg_use_encoded_credentials_explicitly_set=true
				_arg_use_encoded_credentials=true
				test "${1:0:5}" = "--no-" && _arg_use_encoded_credentials=false
				;;
			--no-bt-only|--bt-only)
				_arg_bt_only_explicitly_set=true
				_arg_bt_only=true
				test "${1:0:5}" = "--no-" && _arg_bt_only=false
				;;
			-c|--controller-host)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_controller_host="$2"
				shift
				;;
			--controller-host=*)
				_arg_controller_host="${_key##--controller-host=}"
				;;
			-c*)
				_arg_controller_host="${_key##-c}"
				;;
			-P|--controller-port)
				_arg_controller_port_explicitly_set=true
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_controller_port="$2"
				shift
				;;
			--controller-port=*)
				_arg_controller_port_explicitly_set=true
				_arg_controller_port="${_key##--controller-port=}"
				;;
			-P*)
				_arg_controller_port_explicitly_set=true
				_arg_controller_port="${_key##-P}"
				;;
			--account)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_account="$2"
				shift
				;;
			--account=*)
			    _arg_account_explicitly_set=true
				_arg_account="${_key##--account=}"
				;;
			--no-use-https|--use-https)
				_arg_use_https_explicitly_set=true
				_arg_use_https=true
				test "${1:0:5}" = "--no-" && _arg_use_https=false
				;;
			-u|--username)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_username="$2"
				shift
				;;
			--username=*)
				_arg_username="${_key##--username=}"
				;;
			-u*)
				_arg_username="${_key##-u}"
				;;
			-p|--password)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_password="$2"
				shift
				;;
			--password=*)
				_arg_password="${_key##--password=}"
				;;
			-p*)
				_arg_password="${_key##-p}"
				;;
			--no-use-proxy|--use-proxy)
				_arg_use_proxy=true
				_arg_use_proxy_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_use_proxy=false
				;;
			--proxy-url)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_proxy_url="$2"
				shift
				;;
			--proxy-url=*)
				_arg_proxy_url="${_key##--proxy-url=}"
				;;
			--proxy-port)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_proxy_port="$2"
				shift
				;;
			--proxy-port=*)
				_arg_proxy_port="${_key##--proxy-port=}"
				;;
			-a|--application-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_application_name="$2"
				shift
				;;
			--application-name=*)
				_arg_application_name="${_key##--application-name=}"
				;;
			-a*)
				_arg_application_name="${_key##-a}"
				;;
			--no-include-database|--include-database)
				_arg_include_database=true
				_arg_include_database_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_include_database=false
				;;
			-d|--database-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_database_name="$2"
				shift
				;;
			--database-name=*)
				_arg_database_name="${_key##--database-name=}"
				;;
			-d*)
				_arg_database_name="${_key##-d}"
				;;
			-s|--no-include-sim|--include-sim)
				_arg_include_sim=true
				_arg_include_sim_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_include_sim=false
				;;
			-s*)
				_arg_include_sim=true
				_next="${_key##-s}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-s" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-b|--no-configure-bt|--configure-bt)
				_arg_configure_bt=true
				_arg_configure_bt_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_configure_bt=false
				;;
			-b*)
				_arg_configure_bt=true
				_next="${_key##-b}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-b" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			--no-use-branding|--use-branding)
				_arg_use_branding=true
				_arg_use_branding_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_use_branding=false
				;;
			--logo-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_logo_name="$2"
				shift
				;;
			--logo-name=*)
				_arg_logo_name="${_key##--logo-name=}"
				;;
			--background-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_background_name="$2"
				shift
				;;
			--background-name=*)
				_arg_background_name="${_key##--background-name=}"
				;;
			--no-health-rules-only|--health-rules-only)
				_arg_health_rules_only=true
				_arg_health_rules_only_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_health_rules_only=false
				;;
			--no-overwrite-health-rules|--overwrite-health-rules)
				_arg_health_rules_overwrite=true
				_arg_health_rules_overwrite_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_health_rules_overwrite=false
				;;
			--no-health-rules-overwrite|--health-rules-overwrite)
				_arg_health_rules_overwrite=true
				_arg_health_rules_overwrite_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_health_rules_overwrite=false
				;;
			--health-rules-delete)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_health_rules_delete="$2"
				shift
				;;
			--health-rules-delete=*)
				_arg_health_rules_delete="${_key##--health-rules-delete=}"
				;;
			--no-suppress-action|--suppress-action)
				_arg_suppress_action=true
				_arg_suppress_action_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_suppress_action=false
				;;
			--suppress-start)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_suppress_start="$2"
				shift
				;;
			--suppress-start=*)
				_arg_suppress_start="${_key##--suppress-start=}"
				;;
			--suppress-duration)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_suppress_duration="$2"
				shift
				;;
			--suppress-duration=*)
				_arg_suppress_duration="${_key##--suppress-duration=}"
				;;	
			--no-suppress-upload-files|--suppress-upload-files)
				_arg_suppress_upload_files=true
				_arg_suppress_upload_files_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_suppress_upload_files=false
				;;
			--suppress-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_suppress_name="$2"
				shift
				;;
			--suppress-name=*)
				_arg_suppress_name="${_key##--suppress-name=}"
				;;
			--suppress-delete)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_suppress_delete="$2"
				shift
				;;
			--suppress-delete=*)
				_arg_suppress_delete="${_key##--suppress-delete=}"
				;;
			--no-upload-custom-dashboard|--upload-custom-dashboard)
				_arg_upload_custom_dashboard=true
				_arg_upload_custom_dashboard_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_upload_custom_dashboard=false
				;;
			--no-upload-default-dashboard|--upload-default-dashboard)
				_arg_upload_default_dashboard=true
				_arg_upload_default_dashboard_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_upload_default_dashboard=false
				;;
			--no-rbac-only|--rbac-only)
				_arg_rbac_only=true
				_arg_rbac_only_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_rbac_only=false
				;;
			--rbac-action)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_rbac_action="$2"
				shift
				;;
			--rbac-action=*)
				_arg_rbac_action_explicitly_set=true
				_arg_rbac_action="${_key##--rbac-action=}"
				;;
			--rbac-role-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_rbac_role_name="$2"
				shift
				;;
			--rbac-role-name=*)
				_arg_rbac_role_name="${_key##--rbac-role-name=}"
				;;
			--rbac-role-description)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_rbac_role_description="$2"
				shift
				;;
			--rbac-role-description=*)
				_arg_rbac_role_description="${_key##--rbac-role-description=}"
				;;
			--rbac-saml-group-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_rbac_saml_group_name="$2"
				shift
				;;
			--rbac-saml-group-name=*)
				_arg_rbac_saml_group_name="${_key##--rbac-saml-group-name=}"
				;;
			--rbac-license-rule-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_rbac_license_rule_name="$2"
				shift
				;;
			--rbac-license-rule-name=*)
				_arg_rbac_license_rule_name="${_key##--rbac-license-rule-name=}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			--no-debug|--debug)
				_arg_debug=true
				test "${1:0:5}" = "--no-" && _arg_debug=false
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

handle_passed_args_dependency()
{
	# warning
	if ([ $_arg_use_https = false ] &&  [ ! $_arg_controller_port = "8090" ]); then
		_PRINT_HELP=no warn "WARNING: Value of --controller-port is "${_arg_controller_port}" - note that for on-premises controllers, port 8090 is the default for HTTP"
	fi

	if ([ $_arg_use_https = true ] && ([ ! $_arg_controller_port = "8181" ] && [ ! $_arg_controller_port = "443" ] )); then
		_PRINT_HELP=no warn "WARNING: Value of --controller-port is "${_arg_controller_port}" - note that for on-premises and SaaS controllers, ports 8181 and 443, respectively, are defaults for HTTPS"
	fi

	# error
	if [ $_arg_include_database = true ]; then
		test -z "${_arg_database_name// }" && _PRINT_HELP=yes die "FATAL ERROR: When value of --inlude-database is "${_arg_include_database}" - we require database name to be set (namely: --database-name)" 1
	fi

	if [ $_arg_use_proxy = true ]; then
		test -z "${_arg_proxy_url// }" -o -z "${_arg_proxy_port// }" && _PRINT_HELP=yes die "FATAL ERROR: When value of --use-proxy is "${_arg_use_proxy}" - we require proxy details to be set (namely: --proxy-url and --proxy-port)" 1
	fi
}

handle_mandatory_args()
{
	test -z "${_arg_controller_host// }" && _PRINT_HELP=no die "FATAL ERROR: Controller host must be set" 1
	test -z "${_arg_controller_port// }" && _PRINT_HELP=no die "FATAL ERROR: Controller port must be set" 1
	test -z "${_arg_account// }" && _PRINT_HELP=no die "FATAL ERROR: Account must be set" 1
	test -z "${_arg_username// }" && _PRINT_HELP=no die "FATAL ERROR: Username must be set" 1
	test -z "${_arg_password// }" && _PRINT_HELP=no die "FATAL ERROR: Password must be set" 1
	test -z "${_arg_application_name// }" && _PRINT_HELP=no die "FATAL ERROR: Application name must be set" 1
}

# Additional layer of control when value is set through environment variable or configuration
handle_expected_values_for_args()
{
	if ([ ! $_arg_use_encoded_credentials = false ] && [ ! $_arg_use_encoded_credentials = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: -use-encoded-credentials value \"${_arg_use_encoded_credentials}\" not recognized" 1
	fi

	if ([ ! $_arg_health_rules_only = false ] && [ ! $_arg_health_rules_only = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --health-rules-only value \"${_arg_health_rules_only}\" not recognized" 1
	fi
	
	if ([ ! $_arg_health_rules_overwrite = false ] && [ ! $_arg_health_rules_overwrite = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --health-rules-overwrite value \"${_arg_health_rules_overwrite}\" not recognized" 1
	fi

	if ([ ! $_arg_use_https = false ] && [ ! $_arg_use_https = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --use-https value \"${_arg_use_https}\" not recognized" 1
	fi

	if ([ ! $_arg_include_database = false ] && [ ! $_arg_include_database = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --include-database value \"${_arg_include_database}\" not recognized" 1
	fi

	if ([ ! $_arg_use_proxy = false ] && [ ! $_arg_use_proxy = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --use-proxy value \"${_arg_use_proxy}\" not recognized" 1
	fi

	if ([ ! $_arg_include_sim = false ] && [ ! $_arg_include_sim = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --include-sim value \"${_arg_include_sim}\" not recognized" 1
	fi

	if ([ ! $_arg_configure_bt = false ] && [ ! $_arg_configure_bt = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --configure-bt value \"${_arg_configure_bt}\" not recognized" 1
	fi

	if ([ ! $_arg_bt_only = false ] && [ ! $_arg_bt_only = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --bt-only value \"${_arg_bt_only}\" not recognized" 1
	fi

	if ([ ! $_arg_use_branding = false ] && [ ! $_arg_use_branding = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --use-branding value \"${_arg_use_branding}\" not recognized" 1
	fi

	if ([ ! $_arg_upload_custom_dashboard = false ] && [ ! $_arg_upload_custom_dashboard = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --upload-custom-dashboardvalue \"${_arg_upload_custom_dashboard}\" not recognized" 1
	fi

	if ([ ! $_arg_upload_default_dashboard = false ] && [ ! $_arg_upload_default_dashboard = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --upload-default-dashboard value \"${_arg_upload_default_dashboard}\" not recognized" 1
	fi

	if ([ ! $_arg_rbac_only = false ] && [ ! $_arg_rbac_only = true ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: _arg_rbac_only value \"${_arg_rbac_only}\" not recognized" 1
	fi
}

### 1 SET PARAMETER VALUES ###

# 1.1 Parse script input arguments 
parse_commandline "$@"

# 1.2 If value not set with arguments replace with Environment Variable (if exists)
# Get ConfigMyApp environment variables with: env | grep CMA_

# general
if ([ $_arg_use_encoded_credentials_explicitly_set = false ] && [ ! -z "${CMA_USE_ENCODED_CREDENTIALS// }" ]); then
	_arg_use_encoded_credentials=${CMA_USE_ENCODED_CREDENTIALS}
fi

# controller
if ([ -z "${_arg_controller_host// }" ] && [ ! -z "${CMA_CONTROLLER_HOST// }" ]); then
	_arg_controller_host=${CMA_CONTROLLER_HOST}
fi
if ([ $_arg_controller_port_explicitly_set = false ] && [ ! -z "${CMA_CONTROLLER_PORT// }" ]); then
	_arg_controller_port=${CMA_CONTROLLER_PORT}
fi
if ([ $_arg_use_https_explicitly_set = false ] && [ ! -z "${CMA_USE_HTTPS// }" ]); then
	_arg_use_https=${CMA_USE_HTTPS}
fi

# account
if ([ $_arg_account_explicitly_set = false ] && [ ! -z "${CMA_ACCOUNT// }" ]); then
	_arg_account=${CMA_ACCOUNT}
fi
if ([ -z "${_arg_username// }" ] && [ ! -z "${CMA_USERNAME// }" ]); then
	_arg_username=${CMA_USERNAME}
fi
if ([ -z "${_arg_password// }" ] && [ ! -z "${CMA_PASSWORD// }" ]); then
	_arg_password=${CMA_PASSWORD}
fi

# proxy
if ([ $_arg_use_proxy_explicitly_set = false ] && [ ! -z "${CMA_USE_PROXY// }" ]); then
	_arg_use_proxy=${CMA_USE_PROXY}
fi
if ([ -z "${_arg_proxy_url// }" ] && [ ! -z "${CMA_PROXY_URL// }" ]); then
	_arg_proxy_url=${CMA_PROXY_URL}
fi
if ([ -z "${_arg_proxy_port// }" ] && [ ! -z "${CMA_PROXY_PORT// }" ]); then
	_arg_proxy_port=${CMA_PROXY_PORT}
fi

# branding
if ([ $_arg_use_branding_explicitly_set = false ] && [ ! -z "${CMA_USE_BRANDING// }" ]); then
	_arg_use_branding=${CMA_USE_BRANDING}
fi
if ([ -z "${_arg_logo_name// }" ] && [ ! -z "${CMA_LOGO_NAME// }" ]); then
	_arg_logo_name=${CMA_LOGO_NAME}
fi
if ([ -z "${_arg_background_name// }" ] && [ ! -z "${CMA_BACKGROUND_NAME// }" ]); then
	_arg_background_name=${CMA_BACKGROUND_NAME}
fi

# configuration
if ([ -z "${_arg_application_name// }" ] && [ ! -z "${CMA_APPLICATION_NAME// }" ]); then
	_arg_application_name=${CMA_APPLICATION_NAME}
fi
if ([ $_arg_include_database_explicitly_set = false ] && [ ! -z "${CMA_INCLUDE_DATABASE// }" ]); then
	_arg_include_database=${CMA_INCLUDE_DATABASE}
fi
if ([ -z "${_arg_database_name// }" ] && [ ! -z "${CMA_DATABASE_NAME// }" ]); then
	_arg_database_name=${CMA_DATABASE_NAME}
fi
if ([ $_arg_include_sim_explicitly_set = false ] && [ ! -z "${CMA_INCLUDE_SIM// }" ]); then
	_arg_include_sim=${CMA_INCLUDE_SIM}
fi
if ([ $_arg_configure_bt_explicitly_set = false ] && [ ! -z "${CMA_CONFIGURE_BT// }" ]); then
	_arg_configure_bt=${CMA_CONFIGURE_BT}
fi
if ([ $_arg_bt_only_explicitly_set = false ] && [ ! -z "${CMA_BT_ONLY// }" ]); then
	_arg_bt_only=${CMA_BT_ONLY}
fi

# health rules
if ([[ $_arg_health_rules_only_explicitly_set = false ]] && [ ! -z "${CMA_HEALTH_RULES_ONLY// }" ]); then
	_arg_health_rules_only=${CMA_HEALTH_RULES_ONLY}
fi
# backwards compatability for varaible name
if ([[ $_arg_health_rules_overwrite_explicitly_set = false ]] && [ -z "${CMA_OVERWRITE_HEALTH_RULES// }" ]); then
	_arg_health_rules_overwrite=${CMA_OVERWRITE_HEALTH_RULES}
fi
# but override with newer version if provided
if ([[ $_arg_health_rules_overwrite_explicitly_set = false ]] && [ ! -z "${CMA_HEALTH_RULES_OVERWRITE// }" ]); then
	_arg_health_rules_overwrite=${CMA_HEALTH_RULES_OVERWRITE}
fi
if ([[ -z "${_arg_health_rules_delete// }" ]] && [ ! -z "${CMA_HEALTH_RULES_DELETE// }" ]); then
	_arg_health_rules_delete=${CMA_HEALTH_RULES_DELETE}
fi

# action suppression
if ([ $_arg_suppress_action_explicitly_set = false ] && [ ! -z "${CMA_SUPPRESS_ACTION// }" ]); then
	_arg_suppress_action=${CMA_SUPPRESS_ACTION}
fi
if ([ -z "${_arg_suppress_start// }" ] && [ ! -z "${CMA_SUPPRESS_START// }" ]); then
	_arg_suppress_start=${CMA_SUPPRESS_START}
fi
if ([ -z "${_arg_suppress_duration// }" ] && [ ! -z "${CMA_SUPPRESS_DURATION// }" ]); then
	_arg_suppress_duration=${CMA_SUPPRESS_DURATION}
fi
if ([ -z "${_arg_suppress_name// }" ] && [ ! -z "${CMA_SUPPRESS_NAME// }" ]); then
	_arg_suppress_name=${CMA_SUPPRESS_NAME}
fi
if ([ $_arg_suppress_upload_files_explicitly_set = false ] && [ ! -z "${CMA_SUPPRESS_UPLOAD_FILES// }" ]); then
	_arg_suppress_upload_files=${CMA_SUPPRESS_UPLOAD_FILES}
fi
if ([ -z "${_arg_suppress_delete// }" ] && [ ! -z "${CMA_SUPPRESS_DELETE// }" ]); then
	_arg_suppress_delete=${CMA_SUPPRESS_DELETE}
fi

# upload custom dashboards 
if ([ $_arg_upload_custom_dashboard_explicitly_set = false ] && [ ! -z "${CMA_UPLOAD_CUSTOM_DASHBOARD// }" ]); then
	_arg_upload_custom_dashboard=${CMA_UPLOAD_CUSTOM_DASHBOARD}
fi

# upload default dashboards 
if ([ $_arg_upload_default_dashboard_explicitly_set = false ] && [ ! -z "${CMA_UPLOAD_DEFAULT_DASHBOARD// }" ]); then
	_arg_upload_default_dashboard=${CMA_UPLOAD_DEFAULT_DASHBOARD}
fi

# RBAC
if ([ $_arg_rbac_only_explicitly_set = false ] && [ ! -z "${CMA_RBAC_ONLY// }" ]); then
	_arg_rbac_only=${CMA_RBAC_ONLY}
fi
if ([ $_arg_rbac_action_explicitly_set = false ] && [ ! -z "${CMA_RBAC_ACTION// }" ]); then
	_arg_rbac_action=${CMA_RBAC_ACTION}
fi
if ([ -z "${_arg_rbac_role_name// }" ] && [ ! -z "${CMA_RBAC_ROLE_NAME// }" ]); then
	_arg_rbac_role_name=${CMA_RBAC_ROLE_NAME}
fi
if ([ -z "${_arg_rbac_role_description// }" ] && [ ! -z "${CMA_RBAC_ROLE_DESCRIPTION// }" ]); then
	_arg_rbac_role_description=${CMA_RBAC_ROLE_DESCRIPTION}
fi
if ([ -z "${_arg_rbac_saml_group_name// }" ] && [ ! -z "${CMA_RBAC_SAML_GROUP_NAME// }" ]); then
	_arg_rbac_saml_group_name=${CMA_RBAC_SAML_GROUP_NAME}
fi
if ([ -z "${_arg_rbac_license_rule_name// }" ] && [ ! -z "${CMA_RBAC_LICENSE_RULE_NAME// }" ]); then
	_arg_rbac_saml_group_name=${CMA_RBAC_LICENSE_RULE_NAME}
fi

# 1.3 If value not set replace with configuration file values
conf_file="config.json"

# general
# note: for arguments with default value, set value from config if not explicitly set as argument and environment variable does not exist
if ([ $_arg_use_encoded_credentials_explicitly_set = false ] && [ -z "${CMA_USE_ENCODED_CREDENTIALS}" ]); then
	_arg_use_encoded_credentials=$(jq -r '.are_passwords_encoded' <${conf_file})
fi
# if ([ $_arg_health_rules_overwrite_explicitly_set = false ] && [ -z "${CMA_OVERWRITE_HEALTH_RULES}" ]); then
# 	_arg_health_rules_overwrite=$(jq -r '.overwrite_health_rules' <${conf_file})
# fi

# controller
if [[ -z "${_arg_controller_host// }" ]]; then
	_arg_controller_host=$(jq -r '.controller_details[].host' <${conf_file})
fi

if ([ $_arg_controller_port_explicitly_set = false ] && [ -z "${CMA_CONTROLLER_PORT}" ]); then
	_arg_controller_port=$(jq -r '.controller_details[].port' <${conf_file})
fi

if ([ $_arg_use_https_explicitly_set = false ] && [ -z "${CMA_USE_HTTPS// }" ]); then
 	_arg_use_https=$(jq -r '.controller_details[].use_https' <${conf_file})
fi

# account
if ([ $_arg_account_explicitly_set = false ] && [ -z "${CMA_ACCOUNT}" ]); then
	_arg_account=$(jq -r '.controller_details[].account' <${conf_file})
fi
if [[ -z "${_arg_username// }" ]]; then
	_arg_username=$(jq -r '.controller_details[].username' <${conf_file})
fi
if [[ -z "${_arg_password// }" ]]; then
	_arg_password=$(jq -r '.controller_details[].password' <${conf_file})
fi

# proxy
if ([ $_arg_use_proxy_explicitly_set = false ] && [ -z "${CMA_USE_PROXY// }" ]); then
	_arg_use_proxy=$(jq -r '.controller_details[].use_proxy' <${conf_file})
fi
if [[ -z "${_arg_proxy_url// }" ]]; then
	_arg_proxy_url=$(jq -r '.controller_details[].proxy_url' <${conf_file})
fi
if [[ -z "${_arg_proxy_port// }" ]]; then
	_arg_proxy_port=$(jq -r '.controller_details[].proxy_port' <${conf_file})
fi

# branding
if ([ $_arg_use_branding_explicitly_set = false ] && [ -z "${CMA_USE_BRANDING// }" ]); then
	_arg_use_branding=$(jq -r '.branding[].enabled' <${conf_file})
fi
if [[ -z "${_arg_logo_name// }" ]]; then
	_arg_logo_name=$(jq -r '.branding[].logo_file_name' <${conf_file})
fi
if [[ -z "${_arg_background_name// }" ]]; then
	_arg_background_name=$(jq -r '.branding[].background_file_name' <${conf_file})
fi

# configuration
if [[ -z "${_arg_application_name// }" ]]; then
	_arg_application_name=$(jq -r '.configuration[].application_name' <${conf_file})
fi
if ([[ $_arg_include_database_explicitly_set = false ]] && [ -z "${CMA_INCLUDE_DATABASE// }" ]); then
	_arg_include_database=$(jq -r '.configuration[].include_database' <${conf_file})
fi
if [[ -z "${_arg_database_name// }" ]]; then
	_arg_database_name=$(jq -r '.configuration[].database_name' <${conf_file})
fi
if ([[ $_arg_include_sim_explicitly_set = false ]] && [ -z "${CMA_INCLUDE_SIM// }" ]); then
	_arg_include_sim=$(jq -r '.configuration[].include_sim' <${conf_file})
fi
if ([[ $_arg_configure_bt_explicitly_set = false ]] && [ -z "${CMA_CONFIGURE_BT// }" ]); then
	_arg_configure_bt=$(jq -r '.configuration[].configure_bt' <${conf_file})
fi
if ([[ $_arg_bt_only_explicitly_set = false ]] && [ -z "${CMA_BT_ONLY// }" ]); then
	_arg_bt_only=$(jq -r '.configuration[].bt_only' <${conf_file})
fi

# health rules
if ([[ $_arg_health_rules_only_explicitly_set = false ]] && [ -z "${CMA_HEALTH_RULES_ONLY// }" ]); then
	_arg_health_rules_only=$(jq -r '.health_rules[].health_rules_only' <${conf_file})
fi
if ([[ $_arg_health_rules_overwrite_explicitly_set = false ]] && [ -z "${CMA_HEALTH_RULES_OVERWRITE// }" ]); then
	_arg_health_rules_overwrite=$(jq -r '.health_rules[].health_rules_overwrite' <${conf_file})
fi
if [[ -z "${_arg_health_rules_delete// }" ]]; then
	_arg_health_rules_delete=$(jq -r '.health_rules[].health_rules_delete' <${conf_file})
fi

# action suppression
if ([[ $_arg_suppress_action_explicitly_set = false ]] && [ -z "${CMA_SUPPRESS_ACTION// }" ]); then
	_arg_suppress_action=$(jq -r '.action_suppression[].suppress_action' <${conf_file})
fi
if [[ -z "${_arg_suppress_start// }" ]]; then
	_arg_suppress_start=$(jq -r '.action_suppression[].suppress_start' <${conf_file})
fi
if [[ -z "${_arg_suppress_duration// }" ]]; then
	_arg_suppress_duration=$(jq -r '.action_suppression[].suppress_duration' <${conf_file})
fi
if [[ -z "${_arg_suppress_name// }" ]]; then
	_arg_suppress_name=$(jq -r '.action_suppression[].suppress_name' <${conf_file})
fi
if ([[ $_arg_suppress_upload_files_explicitly_set = false ]] && [ -z "${CMA_SUPPRESS_UPLOAD_FILES// }" ]); then
	_arg_suppress_upload_files=$(jq -r '.action_suppression[].suppress_upload_files' <${conf_file})
fi
if [[ -z "${_arg_suppress_delete// }" ]]; then
	_arg_suppress_delete=$(jq -r '.action_suppression[].suppress_delete' <${conf_file})
fi

# upload custom dashboards
if ([[ $_arg_upload_custom_dashboard_explicitly_set = false ]] && [ -z "${CMA_UPLOAD_CUSTOM_DASHBOARD// }" ]); then
	_arg_upload_custom_dashboard=$(jq -r '.configuration[].upload_custom_dashboard' <${conf_file})
fi

# upload deafult dashboards
if ([[ $_arg_upload_default_dashboard_explicitly_set = false ]] && [ -z "${CMA_UPLOAD_DEFAULT_DASHBOARD// }" ]); then
	_arg_upload_default_dashboard=$(jq -r '.configuration[].upload_default_dashboard' <${conf_file})
fi

# RBAC
if ([[ $_arg_rbac_only_explicitly_set = false ]] && [ -z "${CMA_RBAC_ONLY// }" ]); then
	_arg_rbac_only=$(jq -r '.rbac[].rbac_only' <${conf_file})
fi
if ([[ $_arg_rbac_action_explicitly_set = false ]] && [ -z "${CMA_RBAC_ACTION// }" ]); then
	_arg_rbac_action=$(jq -r '.rbac[].rbac_action' <${conf_file})
fi
if [[ -z "${_arg_rbac_role_name// }" ]]; then
	_arg_rbac_role_name=$(jq -r '.rbac[].rbac_role_name' <${conf_file})
fi
if [[ -z "${_arg_rbac_role_description// }" ]]; then
	_arg_rbac_role_description=$(jq -r '.rbac[].rbac_role_description' <${conf_file})
fi
if [[ -z "${_arg_rbac_saml_group_name// }" ]]; then
	_arg_rbac_saml_group_name=$(jq -r '.rbac[].rbac_saml_group_name' <${conf_file})
fi
if [[ -z "${_arg_rbac_license_rule_name// }" ]]; then
	_arg_rbac_license_rule_name=$(jq -r '.rbac[].rbac_license_rule_name' <${conf_file})
fi

### 2 VALIDATE ###

# 2.1 Check if values are in expected ranges
handle_expected_values_for_args
# 2.2 Check parameter dependency constraints
handle_passed_args_dependency
# 2.3 Check if all mandatory parameters are set
handle_mandatory_args

### END OF ARGS. DO DELETE THIS COMMENT ### ])
# [ <-- needed, do not delete

 #  <-- needed , do not delete

if [ $_arg_debug = true ]; then

	echo "Value of --use-encoded-credentials: $_arg_use_encoded_credentials"
	echo "Value of --health-rules-overwrite: $_arg_health_rules_overwrite"

	echo "Value of --controller-host: $_arg_controller_host"
	echo "Value of --controller-port: $_arg_controller_port"
	echo "Value of --use-https: $_arg_use_https"

	echo "Value of --account: $_arg_account"
	echo "Value of --username: $_arg_username" 
	#echo "Value of --password: $_arg_password" 

	echo "Value of --use-proxy: $_arg_use_proxy"
	echo "Value of --proxy-url: $_arg_proxy_url"
	echo "Value of --proxy-port: $_arg_proxy_port" 

	echo "Value of --application-name: $_arg_application_name" 
	echo "Value of --include-database: $_arg_include_database" 
	echo "Value of --database-name: $_arg_database_name" 
	echo "Value of --include-sim: $_arg_include_sim" 
	echo "Value of --configure-bt: $_arg_configure_bt" 
	echo "Value of --bt-only: $_arg_bt_only" 

	echo "Value of --health-rules-only: ${_arg_health_rules_only}"
	echo "Value of --health-rules-overwrite: ${_arg_health_rules_overwrite}"
	echo "Value of --health-rules-delete: ${_arg_health_rules_delete}"

	echo "Value of --suppress-action: $_arg_suppress_action" 
	echo "Value of --suppress-start: $_arg_suppress_start" 
	echo "Value of --suppress-duration: $_arg_suppress_duration" 
	echo "Value of --suppress-name: $_arg_suppress_name" 
	echo "Value of --suppress-delete: $_arg_suppress_delete" 

	echo "Value of --use-branding: $_arg_use_branding" 
	echo "Value of --logo-name: $_arg_logo_name" 
	echo "Value of --background-name: $_arg_background_name" 

	echo "Value of --upload-custom-dashboard: $_arg_upload_custom_dashboard" 
	echo "Value of --upload-default-dashboard: $_arg_upload_default_dashboard" 

	echo "Value of --rbac-only: $_arg_rbac_only" 
	echo "Value of --rbac-action: $_arg_rbac_action" 
	echo "Value of --rbac-role-name: $_arg_rbac_role_name" 
	echo "Value of --rbac-role-description: $_arg_rbac_role_description" 
	echo "Value of --rbac-saml-group-name: $_arg_rbac_saml_group_name" 
	echo "Value of --rbac-license-rule-name: $_arg_rbac_license_rule_name" 
	
fi

### 3 PREPARE PARAMETERS ###

# 3.1 Prepare user credentials

# remove anything after '@' in username (in case that account is set as part of username value)
_arg_username="$(echo $_arg_username | sed -e 's|@.*$||')"
# decode passwords if encoded
if [ "$_arg_use_encoded_credentials" = true ]; then
    _arg_password=$(eval echo ${_arg_password} | base64 --decode)
fi
# build user credentials
_arg_user_credentials="$_arg_username@$_arg_account:$_arg_password"

# 3.2 Set protocol

# extract protocol based on input flags
if [ $_arg_use_https = true ]; then
	protocol="https"
else 
	protocol="http"
fi

# extract protocol from controller host variable, without trailing :// and convert to lower caps
_arg_controller_host_protocol="$(echo $_arg_controller_host | grep :// | sed -e's,^\(.*://\).*,\1,g' | sed 's/.\{3\}$//' | tr '[:upper:]' '[:lower:]')"

# if host url does not contain protocol
if [ -z "${_arg_controller_host_protocol}" ]; then
	_arg_controller_host_protocol=$protocol
fi

# 3.3 Prepare controller url

# remove anything before // (protocol) and after : or / (path and/or port) in hostname - to keep only domain name
_arg_controller_host="$(echo $_arg_controller_host | sed -e 's|^[^/]*//||' -e 's|/.*$||' -e 's|:.*$||')"

_arg_controller_url="$_arg_controller_host_protocol://$_arg_controller_host:$_arg_controller_port/controller"

if [ "${protocol}" != "${_arg_controller_host_protocol}" ]; then
	echo "WARNING --use-https / --no-use-https flag value '${protocol}' does not match controller host protocol '${_arg_controller_host_protocol}'."
	echo "        Note that controller host protocol takes precedence and final URL to connect to is: '${_arg_controller_url}'."
fi

# 3.4 Prepare proxy details

if [ $_arg_use_proxy = true ]; then
	_arg_proxy_details="-x $_arg_proxy_url:$_arg_proxy_port"
else 
	_arg_proxy_details=""
fi

# 3.5 Prepare branding

_arg_logo_name="./branding/$_arg_logo_name"
_arg_background_name="./branding/$_arg_background_name" 

if [ $_arg_debug = true ]; then
	echo ''
	echo "Config details:"
	echo "User credentials: $_arg_user_credentials"
	echo "Controller URL: $_arg_controller_url"
	echo "Proxy details: $_arg_proxy_details"
	echo "Configure BTs: $_arg_configure_bt"
fi

# 3.5 Prepare action supression
if [ $_arg_suppress_action = true ]; then
	if [ -z "${_arg_suppress_start// }" ]; then
		# set to current datetime if empty
		# UTC / GMT
		_arg_suppress_start=$(date -u +%FT%T+0000)
		echo "DEF|Default action suppression start time created '${_arg_suppress_start}'"
	fi
	if [ -z "${_arg_suppress_duration// }" ]; then
		# set to one hour if empty
		_arg_suppress_duration=60
		echo "DEF|Default action suppression duration created '${_arg_suppress_duration}'"
	fi
fi

# 3.6 Prepare RBAC
if [ $_arg_rbac_only = true ]; then
	# validate action (check if valid option)
	if [[ ! " ${_valid_rbac_actions[@]} " =~ " ${_arg_rbac_action} " ]]; then
		# whatever you want to do when array doesn't contain value
		_PRINT_HELP=no die "FATAL ERROR: --rbac-action value \"${_arg_rbac_action}\" not recognized" 1
	fi

	_rbac_prefix="cma"
	_rbac_rnd=$((1 + $RANDOM % 1000))

	# default saml group name
	if [ -z "${_arg_rbac_saml_group_name// }" ]; then
		# if empty
		_arg_rbac_saml_group_name="${_rbac_prefix}_group_${_arg_application_name}_${_rbac_rnd}"
		echo "DEF|Default RBAC SAML group name created '${_arg_rbac_saml_group_name}'"
	fi

	# default role name
	if [ -z "${_arg_rbac_role_name// }" ]; then
		# if empty
		_arg_rbac_role_name="${_rbac_prefix}_role_${_arg_application_name}_${_rbac_rnd}"
		echo "DEF|Default RBAC role name created '${_arg_rbac_role_name}'"
	fi

	if [ -z "${_arg_rbac_license_rule_name// }" ]; then
		_arg_rbac_license_rule_name="${_rbac_prefix}_rule" # more than one rule can be uploaded during a single run, rand added in module
    	echo "DEF|License rule name created '${_arg_rbac_license_rule_name}'"
	fi
	
fi

## VALIDATIONS [prereqs]
## 1. packages

./modules/validations/packages.sh; ec=$? 

case $ec in
    0) ;;
    1) printf '%s\n' "Command exited with non-zero code"; exit 1;;
esac

## 2. contrtoller connection
./modules/validations/controller.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_proxy_details" ; ec=$? 

case $ec in
    0) ;;
    1) printf '%s\n' "Command exited with non-zero code"; exit 1;;
esac

## 3. application

./modules/validations/application.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_proxy_details" "$_arg_application_name"; ec=$? 

case $ec in
    0) ;;
    1) printf '%s\n' "Command exited with non-zero code"; exit 1;;
esac

### RBAC ###
if ([[ $_arg_rbac_only = true ]] && [ $_arg_rbac_action = "role-saml" ]); then
	echo -e "\n> Running 'RBAC' module"
	echo -e ">> Action 'Create Role and SAML Attach'\n"
	./modules/rbac/create_role_with_app_edit_and_attach_to_saml.sh  "$_arg_controller_url" "$_arg_user_credentials" "$_arg_proxy_details" "$_arg_application_name" "$_arg_debug" "$_arg_rbac_role_name" "$_arg_rbac_role_description" "$_arg_rbac_saml_group_name"
fi

if ([[ $_arg_rbac_only = true ]] && [ $_arg_rbac_action = "license-rule" ]); then
	echo -e "\n> Running 'RBAC' module"
	echo -e ">> Action 'Create License Rule'\n"
	./modules/rbac/create_license_rules.sh  "$_arg_controller_url" "$_arg_user_credentials" "$_arg_proxy_details" "$_arg_application_name" "$_arg_debug" "$_arg_rbac_license_rule_name"
fi

### 4 ACTION SUPRESSION ###
if [ $_arg_suppress_action = true ]; then
	echo -e "\n> Running 'Action Supression' module"
	echo -e ">> Action 'Create'\n"
	./modules/actions/application-action-suppression.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_proxy_details" "$_arg_application_name" "$_arg_suppress_start" "$_arg_suppress_duration" "$_arg_suppress_name" "$_arg_debug"
fi

if [ $_arg_suppress_upload_files = true ]; then
	echo -e "\n> Running 'Action Supression' module"
	echo -e ">> Action 'Upload from File'\n"
	./modules/actions/upload-files-action-suppression.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_proxy_details" "$_arg_application_name" "$_arg_debug"
fi

if [[ ! -z "${_arg_suppress_delete// }" ]]; then
	echo -e "\n> Running 'Action Supression' module"
	echo -e ">> Action 'Delete'\n"
	./modules/actions/delete-action-suppression.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_proxy_details" "$_arg_application_name" "$_arg_suppress_delete" "$_arg_debug"
fi

### 5 CUSTOM DASHBOARDS ###
if [ $_arg_upload_custom_dashboard = true ]; then
	echo -e "\n> Running 'Custom Dashboard' module\n"
	./modules/dashboards/upload_custom_dashboard.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_application_name" "$_arg_proxy_details" "$_arg_debug"
fi

### PREDEFINED/default DASHBOARDS
if [ $_arg_upload_default_dashboard = true ]; then
	echo -e "\n> Running 'Default Dashboard' module\n"
	./modules/dashboards/upload_default_dashboard.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_application_name" "$_arg_proxy_details" "$_arg_include_database" "$_arg_database_name" "$_arg_include_sim" "$_arg_use_branding" "$_arg_background_name" "$_arg_logo_name" "$_arg_debug"
fi

### 6 HEALTH RULES ###
if [ $_arg_health_rules_only = true ]; then
	echo -e "\n> Running 'Health Rules' module"
	echo -e ">> Action 'Upload from File'\n"
	./modules/health_rules/upload_health_rules.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_application_name" "$_arg_proxy_details" "$_arg_health_rules_overwrite" "$_arg_include_sim" "$_arg_debug"
fi

if [ ! -z "${_arg_health_rules_delete// }" ]; then
	echo -e "\n> Running 'Health Rules' module"
	echo -e ">> Action 'Delete'\n"
	./modules/health_rules/delete_health_rules.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_application_name" "$_arg_proxy_details" "$_arg_health_rules_delete" "$_arg_debug"
fi

### BUSINESS TRANSACTIONS
if [ $_arg_bt_only = true ]; then
	echo -e "\n> Running 'Business Transactions' module\n"
	./modules/business_transactions/configBT.sh "$_arg_controller_url" "$_arg_user_credentials" "$_arg_application_name" 
fi

# ] <-- needed, do not delete
 #  <-- needed, do not delete 