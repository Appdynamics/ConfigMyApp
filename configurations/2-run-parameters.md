---
sort: 2
---

# Runtime parameters  

Use the `--help` command to get a list of the available runtime parameters as shown below:

```
./start.sh --help
```

The table below describes the supported runtime arguments: 

| Section       | Parameter<img>  | Description  | Mandatory  |
| ------ |:------- | :--------- |  :----: |
| Connection | `-c, --controller-host` | controller host (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Connection | `-P, --controller-port` | controller port (8090 by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Connection | `--use-https, --no-use-https` | if true, specifies that the agent should use SSL (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Account | `--account` | account name (customer1 by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `-u, --username` | appd user username (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `-p, --password` | appd user password (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `--use-encoded-credentials, --no-use-encoded-credentials` | use base64 encoded credentials (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `--use-proxy, --no-use-proxy` | use proxy optional argument (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `--proxy-url` | proxy url (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `--proxy-port` | proxy port (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `--use-branding, --no-use-branding` | enable branding (true by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `--logo-name` | logo image file name (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `--background-name` | background image file name (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-a, --application-name` | application name (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Application | `--include-database, --no-include-database` | include database (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-d, --database-name` | database name, mandatory if include-database set to true (no default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-s, --include-sim` | include server visibility (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-b, --configure-bt` | configure busness transactions (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `--overwrite-health-rules` | overwrite health rules (true by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `--bt-only, --no-bt-only` | configure business transactions only (false by default)  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `--upload-custom-dashboard` | upload custom dashboard from existing JSON file (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `--upload-default-dashboard` | upload default dashboard (true by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `--suppress-action, --no-suppress-action` | use application action suppression (false by default)  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `--suppress-start` | application suppression start date in "yyyy-MM-ddThh:mm:ss+0000" format (GMT) (current datetime by default)  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `--suppress-duration` | application suppression duration in minutes (one hour by default)  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `--suppress-name` | custom name of the supression action, if none specified name is auto-generated  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `--suppress-upload-files, --no-suppress-upload-files` | upload action suppression files from a folder (false by default)  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Action Suppression | `--suppress-delete` | delete action suppression by passing action name to this parameter (no default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `--rbac-only` | configure RBAC (false by default)|  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `--rbac-action` | RBAC action to be performed (rbac-saml by default)|  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `--rbac-role-name` | RBAC role name (auto-generated by default)|  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `--rbac-role-description` | RBAC role description, not mandatory (no default)|  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `--rbac-saml-group-name` | RBAC SAML group name (auto-generated by default)|  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| RBAC | `--rbac-license-rule-name` | License rule name (auto-generated by default)|  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |


You can run the script in debug mode by using `--debug` flag, in which case the connection and other parameters used will be printed out in the console. We do not recommend using this flag in production, and it is set to `false` by default.
