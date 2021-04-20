---
sort: 3
---

# Environment variables

Environment variables used by ConfigMyApp start with `CMA_` and if not empty, will be used to fill-in parameters values not explicitly set at runtime. <br>

The table below describes the supported environment variables:

<table>
    <thead>
      <tr>
        <th>Section</th>
        <th style="text-align: left">Environment Variable</th>
        <th style="text-align: left">Description</th>
        <th style="text-align: center">Mandatory</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Connection</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_CONTROLLER_HOST</code></td>
        <td style="text-align: left">controller host</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Connection</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_CONTROLLER_PORT</code></td>
        <td style="text-align: left">controller port</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Connection</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_HTTPS</code></td>
        <td style="text-align: left">if true, specifies that the agent should use SSL</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Account</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_ACCOUNT</code></td>
        <td style="text-align: left">account name</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Account</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USERNAME</code></td>
        <td style="text-align: left">appd user username</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Account</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_PASSWORD</code></td>
        <td style="text-align: left">appd user password (no default)</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Account</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_ENCODED_CREDENTIALS</code></td>
        <td style="text-align: left">use base64 encoded credentials</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Proxy</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_PROXY</code></td>
        <td style="text-align: left">use proxy</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Proxy</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_PROXY_URL</code></td>
        <td style="text-align: left">proxy url</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Proxy</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_PROXY_PORT</code></td>
        <td style="text-align: left">proxy port</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Branding</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_BRANDING</code></td>
        <td style="text-align: left">enable branding</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Branding</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_LOGO_NAME</code></td>
        <td style="text-align: left">logo image file name</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Branding</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_BACKGROUND_NAME</code></td>
        <td style="text-align: left">background image file name</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_APPLICATION_NAME</code></td>
        <td style="text-align: left">application name</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_INCLUDE_DATABASE</code></td>
        <td style="text-align: left">include database</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_DATABASE_NAME</code></td>
        <td style="text-align: left">database name, mandatory if include-database set to true</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_INCLUDE_SIM</code></td>
        <td style="text-align: left">include server visibility</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_CONFIGURE_BT</code></td>
        <td style="text-align: left">configure busness transactions</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_OVERWRITE_HEALTH_RULES</code></td>
        <td style="text-align: left">overwrite health rules</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        
        <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_HEALTH_RULES_ONLY</code></td>
        <td style="text-align: left">create health rules only</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        
      <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_BT_ONLY</code></td>
        <td style="text-align: left">configure business transactions only</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_UPLOAD_CUSTOM_DASHBOARD</code></td>
        <td style="text-align: left">Upload existing custom dashboard</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
       <tr>
        <td>Application</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_UPLOAD_DEFAULT_DASHBOARD</code></td>
        <td style="text-align: left">Upload default dashboard</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        <tr>
        <td>Action Suppression</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_SUPPRESS_ACTION</code></td>
        <td style="text-align: left">use application action suppression</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        <tr>
        <td>Action Suppression</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_SUPPRESS_START</code></td>
        <td style="text-align: left">application suppression start date in "yyyy-MM-ddThh:mm:ss+0000" format (GMT)</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        <tr>
        <td>Action Suppression</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_SUPPRESS_DURATION</code></td>
        <td style="text-align: left">application suppression duration in minutes</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        <tr>
        <td>Action Suppression</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_SUPPRESS_NAME</code></td>
        <td style="text-align: left">custom name of the supression action, if none specified name is auto-generated </td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        <tr>
        <td>Action Suppression</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_SUPPRESS_UPLOAD_FILES</code></td>
        <td style="text-align: left">upload action suppression files from a folder</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
        <tr>
        <td>Action Suppression</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_SUPPRESS_DELETE</code></td>
        <td style="text-align: left">delete action suppression by setting action name to this variable</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      </tr>
        <tr>
        <td>RBAC</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_RBAC_ONLY</code></td>
        <td style="text-align: left">uses RBAC module when set to true</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      </tr>
        <tr>
        <td>RBAC</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_RBAC_ACTION</code></td>
        <td style="text-align: left"> RBAC action to be performed (rbac-saml by default)</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      </tr>
        <tr>
        <td>RBAC</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_RBAC_ROLE_NAME</code></td>
        <td style="text-align: left">RBAC role name (auto-generated by default)</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      </tr>
        <tr>
        <td>RBAC</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_RBAC_ROLE_DESCRIPTION</code></td>
        <td style="text-align: left">RBAC role description, not mandatory (no default)</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      </tr>
        <tr>
        <td>RBAC</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_RBAC_SAML_GROUP_NAME</code></td>
        <td style="text-align: left">RBAC SAML group name (auto-generated by default)</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>
      </tr>
        <tr>
        <td>RBAC</td>
        <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_RBAC_LICENSE_RULE_NAME</code></td>
        <td style="text-align: left">License rule name (auto-generated by default)</td>
        <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
      </tr>

         
    </tbody>
  </table>
