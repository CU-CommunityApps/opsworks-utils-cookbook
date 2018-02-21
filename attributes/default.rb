

default['opsworks-utils']['alarms']['disk-space-alarm']['period'] = 300
default['opsworks-utils']['alarms']['disk-space-alarm']['evaluation_periods'] = 2
default['opsworks-utils']['alarms']['disk-space-alarm']['threshold'] = 90
default['opsworks-utils']['alarms']['disk-space-alarm']['statistic'] = 'Average'
default['opsworks-utils']['alarms']['disk-space-alarm']['enabled'] = true

default['opsworks-utils']['alarms']['memory-utilization-alarm']['period'] = 300
default['opsworks-utils']['alarms']['memory-utilization-alarm']['evaluation_periods'] = 2
default['opsworks-utils']['alarms']['memory-utilization-alarm']['threshold'] = 80
default['opsworks-utils']['alarms']['memory-utilization-alarm']['statistic'] = 'Average'
default['opsworks-utils']['alarms']['memory-utilization-alarm']['enabled'] = true

default['opsworks-utils']['alarms']['swap-utilization-alarm']['period'] = 300
default['opsworks-utils']['alarms']['swap-utilization-alarm']['evaluation_periods'] = 2
default['opsworks-utils']['alarms']['swap-utilization-alarm']['threshold'] = 50
default['opsworks-utils']['alarms']['swap-utilization-alarm']['statistic'] = 'Average'
default['opsworks-utils']['alarms']['swap-utilization-alarm']['enabled'] = true

default['opsworks-utils']['alarms']['status-check-alarm']['period'] = 60
default['opsworks-utils']['alarms']['status-check-alarm']['evaluation_periods'] = 1
default['opsworks-utils']['alarms']['status-check-alarm']['threshold'] = 1
default['opsworks-utils']['alarms']['status-check-alarm']['statistic'] = 'Maximum'
default['opsworks-utils']['alarms']['status-check-alarm']['enabled'] = true

default['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['period'] = 60
default['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['evaluation_periods'] = 1

# Alarm threshold is set at threshold_hourly_credits_multiplier * (the credits that an instance type earns each hour)
default['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['threshold_hourly_credits_multiplier'] = 0.10
default['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['statistic'] = 'Average'
default['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['enabled'] = true

default['opsworks-utils']['alarms']['cpu-utilization-alarm']['period'] = 300
default['opsworks-utils']['alarms']['cpu-utilization-alarm']['evaluation_periods'] = 2
default['opsworks-utils']['alarms']['cpu-utilization-alarm']['threshold'] = 80
default['opsworks-utils']['alarms']['cpu-utilization-alarm']['statistic'] = 'Average'
default['opsworks-utils']['alarms']['cpu-utilization-alarm']['enabled'] = true