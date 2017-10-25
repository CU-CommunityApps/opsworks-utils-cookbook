# opsworks-utils-cookbook

Standard, shared recipes for use in OpsWorks.

## Custom JSON - Papetrail setup for (recipe - papertrail.rb ) 

You need to configure the exact Papertrail target using OpsWorks custom JSON.

```json
{
  "remote_syslog2" : {
    "config" : {
      "files" : [
        "/var/chef/runs/**/chef.log",
        "/var/log/sssd/*.log",
        "/var/log/syslog",
        "/var/log/auth.log"
      ],
      "exclude_files" : [],
      "exclude_patterns" : [],
      "destination" : {
        "host" : "logsXXX.papertrailapp.com",
        "port" : 12345,
        "protocol" : "tls"
      }
    }
  }
}
```

## Recipes support Amazon Linux and RedHat

Logic has specific testing for platform "redhat" and installs custom packages for redhat. 

