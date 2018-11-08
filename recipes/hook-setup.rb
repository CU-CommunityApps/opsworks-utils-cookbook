# Recipe to be run on brand new instances and at instance start (after a stop).

include_recipe 'opsworks-utils-cookbook::se-linux-mode'
include_recipe 'opsworks-utils-cookbook::papertrail'
include_recipe 'opsworks-utils-cookbook::instance-tags'
include_recipe 'opsworks-utils-cookbook::aws-agents'
include_recipe 'opsworks-utils-cookbook::aws-alarms'
include_recipe 'opsworks-utils-cookbook::packages'
include_recipe 'opsworks-utils-cookbook::timezone'
include_recipe 'opsworks-utils-cookbook::dns-create'
include_recipe 'opsworks-utils-cookbook::ttype-cpu-limit'
