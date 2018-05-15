# opsworks-utils-cookbook

Standard, shared recipes for use in OpsWorks.

These recipes have been tested/used on the following linux distributions:
* Amazon Linux
* RedHat 7
* Centos 7

## Configuration

### Papertrail

Recipe: papertrail

You need to configure the exact Papertrail target using OpsWorks custom JSON. Replace `logsXXX.papertrailapp.com` and `1234` with values for your Papertrail account.

```json
{
  "papertrail": {
    "files": [
        "/var/log/cloud-init.log",
        "/var/log/yum.log"
    ],
    "host": "logsXXX.papertrailapp.com",
    "port": "1234",
    "protocol": "tls"
  }
}
```
