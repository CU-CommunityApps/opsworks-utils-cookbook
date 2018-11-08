stack = search('aws_opsworks_stack').first
instance = search('aws_opsworks_instance', 'self:true').first

node['opsworks-utils']['alarms']['disk-space-alarm']['targets'].each do |filesystem|
  safe_filesystem = filesystem.tr('/ ', '%-')
  aws_cloudwatch "disk-space-alarm-#{safe_filesystem}" do
    alarm_name          "#{stack['name']}-#{instance['hostname']}-disk-space-alarm-#{safe_filesystem}".tr(' ', '-')
    period              node['opsworks-utils']['alarms']['disk-space-alarm']['period']
    evaluation_periods  node['opsworks-utils']['alarms']['disk-space-alarm']['evaluation_periods']
    threshold           node['opsworks-utils']['alarms']['disk-space-alarm']['threshold']
    statistic           node['opsworks-utils']['alarms']['disk-space-alarm']['statistic']
    comparison_operator 'GreaterThanThreshold'
    metric_name         'DiskSpaceUtilization'
    namespace           'System/Linux'
    dimensions [{ name: 'InstanceId', value: instance['ec2_instance_id'] }, { name: 'MountPath', value: filesystem }, { name: 'Filesystem', value: node['filesystem2']['by_mountpoint'][filesystem]['devices'].first }]
    action :nothing
    actions_enabled true
    alarm_actions node['alarms']['notify_sns_topic_arns']
    only_if { node['opsworks-utils']['alarms']['disk-space-alarm']['enabled'] }
  end
end

aws_cloudwatch 'memory-utilization-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-memory-utilization-alarm".tr(' ', '-')
  period              node['opsworks-utils']['alarms']['memory-utilization-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['memory-utilization-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['memory-utilization-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['memory-utilization-alarm']['statistic']
  comparison_operator 'GreaterThanThreshold'
  metric_name         'MemoryUtilization'
  namespace           'System/Linux'
  dimensions [{ name: 'InstanceId', value: instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
  only_if { node['opsworks-utils']['alarms']['memory-utilization-alarm']['enabled'] }
end

aws_cloudwatch 'swap-utilization-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-swap-utilization-alarm".tr(' ', '-')
  period              node['opsworks-utils']['alarms']['swap-utilization-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['swap-utilization-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['swap-utilization-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['swap-utilization-alarm']['statistic']
  comparison_operator 'GreaterThanThreshold'
  metric_name         'SwapUtilization'
  namespace           'System/Linux'
  dimensions [{ name: 'InstanceId', value: instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
  only_if { node['opsworks-utils']['alarms']['swap-utilization-alarm']['enabled'] }
end

aws_cloudwatch 'status-check-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-status-check-alarm".tr(' ', '-')
  period              node['opsworks-utils']['alarms']['status-check-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['status-check-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['status-check-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['status-check-alarm']['statistic']
  comparison_operator 'GreaterThanOrEqualToThreshold'
  metric_name         'StatusCheckFailed'
  namespace           'AWS/EC2'
  dimensions [{ name: 'InstanceId', value: instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
  only_if { node['opsworks-utils']['alarms']['status-check-alarm']['enabled'] }
end

t_credits_map = { 't2.nano' => 3,
                  't2.micro' => 6,
                  't2.small' => 12,
                  't2.medium' => 24,
                  't2.large' => 36,
                  't2.xlarge' => 54,
                  't2.2xlarge' => 81,
                  't3.nano' => 6,
                  't3.micro' => 12,
                  't3.small' => 24,
                  't3.medium' => 24,
                  't3.large' => 36,
                  't3.xlarge' => 96,
                  't3.2xlarge' => 192 }
# Set the default value for non-existant keys
t_credits_map.default = 0

aws_cloudwatch 'cpu-credits-balance-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-cpu-credits-balance-alarm".tr(' ', '-')
  period              node['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['evaluation_periods']
  threshold           (node['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['threshold_hourly_credits_multiplier'] * t_credits_map[instance['instance_type']]).round
  statistic           node['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['statistic']
  comparison_operator 'LessThanOrEqualToThreshold'
  metric_name         'CPUCreditBalance'
  namespace           'AWS/EC2'
  dimensions [{ name: 'InstanceId', value: instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
  only_if { instance['instance_type'].start_with?('t') && node['opsworks-utils']['alarms']['cpu-credits-balance-alarm']['enabled'] }
end

aws_cloudwatch 'cpu-utilization-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-cpu-utilization-alarm".tr(' ', '-')
  period              node['opsworks-utils']['alarms']['cpu-utilization-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['cpu-utilization-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['cpu-utilization-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['cpu-utilization-alarm']['statistic']
  comparison_operator 'GreaterThanThreshold'
  metric_name         'CPUUtilization'
  namespace           'AWS/EC2'
  dimensions [{ name: 'InstanceId', value: instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
  only_if { node['opsworks-utils']['alarms']['cpu-utilization-alarm']['enabled'] }
end
