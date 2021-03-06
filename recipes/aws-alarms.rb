#### ALARMS
include_recipe 'opsworks-utils-cookbook::aws-alarms-definition'

node['opsworks-utils']['alarms']['disk-space-alarm']['targets'].each do |filesystem|
  safe_filesystem = filesystem.tr('/ ', '%-')
  log "Setting up cloudwatch alarm: disk space  for #{filesystem}" do
    notifies :create, "aws_cloudwatch[disk-space-alarm-#{safe_filesystem}]", :immediately
  end
end

log 'Setting up cloudwatch alarm: memory utilization' do
  notifies :create, 'aws_cloudwatch[memory-utilization-alarm]', :immediately
end

log 'Setting up cloudwatch alarm: swap utilization' do
  notifies :create, 'aws_cloudwatch[swap-utilization-alarm]', :immediately
end

log 'Setting up cloudwatch alarm: status check failed' do
  notifies :create, 'aws_cloudwatch[status-check-alarm]', :immediately
end

log 'Setting up cloudwatch alarm: cpu credits balance alarm' do
  notifies :create, 'aws_cloudwatch[cpu-credits-balance-alarm]', :immediately
end

log 'Setting up cloudwatch alarm: cpu utilization' do
  notifies :create, 'aws_cloudwatch[cpu-utilization-alarm]', :immediately
end
