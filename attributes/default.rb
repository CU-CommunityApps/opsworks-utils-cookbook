

default['opsworks-utils']['alarms']['disk-space-alarm']['period'] = 600
default['opsworks-utils']['alarms']['disk-space-alarm']['evaluation_periods'] = 2
default['opsworks-utils']['alarms']['disk-space-alarm']['threshold'] = 90
default['opsworks-utils']['alarms']['disk-space-alarm']['statistic'] = 'Average'

default['opsworks-utils']['alarms']['memory-utilization-alarm']['period'] = 600
default['opsworks-utils']['alarms']['memory-utilization-alarm']['evaluation_periods'] = 2
default['opsworks-utils']['alarms']['memory-utilization-alarm']['threshold'] = 80
default['opsworks-utils']['alarms']['memory-utilization-alarm']['statistic'] = 'Average'

default['opsworks-utils']['alarms']['swap-utilization-alarm']['period'] = 600
default['opsworks-utils']['alarms']['swap-utilization-alarm']['evaluation_periods'] = 2
default['opsworks-utils']['alarms']['swap-utilization-alarm']['threshold'] = 50
default['opsworks-utils']['alarms']['swap-utilization-alarm']['statistic'] = 'Average'

default['opsworks-utils']['alarms']['status-check-alarm']['period'] = 60
default['opsworks-utils']['alarms']['status-check-alarm']['evaluation_periods'] = 1
default['opsworks-utils']['alarms']['status-check-alarm']['threshold'] = 1
default['opsworks-utils']['alarms']['status-check-alarm']['statistic'] = 'Maximum'