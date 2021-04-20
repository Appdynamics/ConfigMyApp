---
sort: 10

---
# RBAC Module - Upload Roles and Permissions [Beta]

ConfigMyApp now also comes with Role-Base Access Control functionality that matches perfectly with Cluster Agent monitoring use-case. After the deployment of agents is automated in Kubernetes or OpenShift environments, in order to enable teams to view and manage their cluster-agent or init-container instrumented applications, uploading roles and permissions to the controller becomes crucial. 

Action available in this module,`role-saml`, creates a Role in controller Administration/Roles that allows users to **View **all applications and **View and **Edit the target application (see `--application-name` in <a href="https://appdynamics.github.io/ConfigMyApp/configurations/1-configuration.html" target="_blank"> configuration </a>). 

Created role is linked to existing SAML group (if group name provided matches any existing ones), or in case that group does not exist, the new one is created.

Running module multiple times with the same SAML group name and different Role names would create multiple Roles and link them to the same SAML group. There is no unnecessary group creation here.

<b> Runtime parameters</b>

The runtime parameter that controls running this module is `--rbac-only` / `--no-rbac-only` and it defaults to `false`. In order to run his module using runtime parameters, run the following:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --rbac-only`

Note that multiple actions can be performed in this module, but the action defaults to `role-saml` in this case even though not explicitly set. To explicitly set an action pass the value to the `--rbac-action` parameter:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --rbac-only --rbac-action="role-saml"`

If no names for RBAC role and/or SAML group name are provided, they are going to be auto-generated, however, recommended approach is to create intuitiv names during this process:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --rbac-only --rbac-role-name="team-pluto-role" --rbac-saml-group-name="existing-or-saml-group-to-be-created-name"`

Role description can be provided as well, and this time let's assume that Role and SAML group names should be auto-generated:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --rbac-only --rbac-role-description="my team's role to control their apps"`

<b>Environment variables</b>

`CMA_RBAC_ONLY=true`
`CMA_RBAC_ACTION="role-saml"`
`CMA_RBAC_ROLE_NAME="provide role name here"`
`CMA_RBAC_ROLE_DESCRIPTION="describe role purpose here"`
`CMA_RBAC_SAML_GROUP_NAME="provide saml group name here"`

<b>Configuration file (`config.json`)</b>

```
"rbac": [ 
    {
      [truncated]
      "rbac_only": true,
      "rbac_action": "role-saml",
      "rbac_role_name": "provide role name here",
      "rbac_role_description": "describe role purpose here",
      "rbac_saml_group_name": "provide saml group name here"
    }
  ],

```

> Note: This feature is using non-official (restui) APIs and in case of new release of a controller with major updates may not function as expected. For that reason, it is permanently in Beta phase until official APIs provide this functionality. 
