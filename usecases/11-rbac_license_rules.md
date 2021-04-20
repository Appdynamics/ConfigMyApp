---
sort: 11

---
# RBAC Module - License Rules [Beta]

License rules enable you to control number of licenses consumed. For more details refer to the documentation <a href="https://docs.appdynamics.com/display/PRO21/License+Management+in+the+Controller">here</a>. 

Action available in this module,`license-rule`, creates a License Rule Administration/Licenses that allows users with a generated key to consume licenses for **all applications and/or at the **target application only (see `--application-name` in <a href="https://appdynamics.github.io/ConfigMyApp/configurations/1-configuration.html" target="_blank"> configuration </a>). 

To control imported licenses, refer to project directory `rbac/restui_license_rules_files/` and it's content. 
- to import license rule for **all applications - make sure you have `payload_all.json` in the directory
- to import license rules for **target application - make sure you have `payload_app.json` in the directory

> Default number of licenses assigned is zero.

<b> Runtime parameters</b>

The runtime parameter that controls running this module is `--rbac-only` / `--no-rbac-only` and it defaults to `false`. To set an license rule creation action, pass the value to the `--rbac-action` parameter with `license-rule` as value:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --rbac-only --rbac-action="license-rule"`

To set a rule name use `--rbac-license-rule-name`:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --rbac-only --rbac-action="license-rule" --rbac-license-rule-name="team-pluto-usage-rule"`

<b>Environment variables</b>

`CMA_RBAC_ONLY=true`
`CMA_RBAC_ACTION="license-rule"`
`CMA_RBAC_LICENSE_RULE_NAME="specify rule name here"`

<b>Configuration file (`config.json`)</b>

```
"rbac": [ 
    {
      [truncated]
      "rbac_only": true,
      "rbac_action": "license-rule",
      "rbac_license_rule_name": "specify rule name here"
    }
  ],

```

> Note: This feature is using non-official (restui) APIs and in case of new release of a controller with major updates may not function as expected. For that reason, it is permanently in Beta phase until official APIs provide this functionality. 