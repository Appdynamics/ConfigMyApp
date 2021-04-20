---
sort: 4
---

# Configuration file

ConfigMyApp uses a `config.json` configuration file which can be found in the root of the project.

The values in the configuration file are only used when the runtime parameter is not defined and the environment for the same parameter does not exist.

The table below describe the JSON configuration:

| Section       | JSON path  | Description  | Mandatory |
| ------ |:------- | :--------- |  :----: |
| Connection | `.controller_details[].host` | controller host | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Connection | `.controller_details[].port` | controller port | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Connection | `.controller_details[].use_https` | if true, specifies that the agent should use SSL | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Account | `.controller_details[].account` | account name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `.controller_details[].username` | appd user username | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `.controller_details[].password` | appd user password (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `.are_passwords_encoded` | use base64 encoded credentials  | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `.controller_details[].use_proxy` | use proxy | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `.controller_details[].proxy_url` | proxy url | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `.controller_details[].proxy_port` | proxy port | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `.branding[].enabled` | enable branding | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `.branding[].logo_file_name` | logo image file name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `.branding[].background_file_name` | background image file name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].application_name` | application name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Application | `.configuration[].include_database` | include database | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].database_name` | database name, mandatory if include-database set to true |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].include_sim` | include server visibility |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].configure_bt` | configure business transactions |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.overwrite_health_rules` | overwrite health rules |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20">|
| Application | `.configuration[].bt_only` | configure business transactions only  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].upload_custom_dashboard` | Upload existing custom dashboard (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].upload_default_dashboard` | Upload default dashboard (true by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `.action_suppression[].suppress_action` |use application action suppression (false by default)  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `.action_suppression[].suppress_start` |application suppression start date in "yyyy-MM-ddThh:mm:ss+0000" format (GMT) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `.action_suppression[].suppress_duration` |application suppression duration in minutes |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `.action_suppression[].suppress_name` |custom name of the supression action, if none specified name is auto-generated |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `.action_suppression[].suppress_upload_files` |upload action suppression files from a folder (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `.action_suppression[].suppress_delete` |delete action suppression by passing action name to this parameter (no default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `.rbac[].rbac_only` |configure RBAC (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `.rbac[].rbac_action` |RBAC action to be performed (rbac-saml by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `.rbac[].rbac_role_name` |RBAC role name (auto-generated by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `.rbac[].rbac_role_description` |RBAC role description, not mandatory (no default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `.rbac[].rbac_saml_group_name` |RBAC SAML group name (auto-generated by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `.rbac[].rbac_license_rule_name` |License rule name (auto-generated by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |

