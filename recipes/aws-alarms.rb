stack = search('aws_opsworks_stack').first
instance = search('aws_opsworks_instance', 'self:true').first

aws_cloudwatch 'disk-space-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-disk-space-alarm".gsub(' ', '-')
  period              node['opsworks-utils']['alarms']['memory-utilization-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['memory-utilization-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['memory-utilization-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['memory-utilization-alarm']['statistic']
  comparison_operator 'GreaterThanThreshold'
  metric_name         'DiskSpaceUtilization'
  namespace           'System/Linux'
  statistic           node['opsworks-utils']['alarms']['memory-utilization-alarm']['statistic']
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }, { :name => 'MountPath', :value => '/' }, { :name => 'Filesystem', :value => '/dev/xvda1' }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end

aws_cloudwatch 'memory-utilization-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-memory-utilization-alarm".gsub(' ', '-')
  period              node['opsworks-utils']['alarms']['memory-utilization-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['memory-utilization-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['memory-utilization-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['memory-utilization-alarm']['statistic']
  comparison_operator 'GreaterThanThreshold'
  metric_name         'MemoryUtilization'
  namespace           'System/Linux'
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end

aws_cloudwatch 'swap-utilization-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-swap-utilization-alarm".gsub(' ', '-')
  period              node['opsworks-utils']['alarms']['swap-utilization-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['swap-utilization-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['swap-utilization-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['swap-utilization-alarm']['statistic']
  comparison_operator 'GreaterThanThreshold'
  metric_name         'SwapUtilization'
  namespace           'System/Linux'
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end

aws_cloudwatch 'status-check-alarm' do
  alarm_name          "#{stack['name']}-#{instance['hostname']}-status-check-alarm".gsub(' ', '-')
  period              node['opsworks-utils']['alarms']['status-check-alarm']['period']
  evaluation_periods  node['opsworks-utils']['alarms']['status-check-alarm']['evaluation_periods']
  threshold           node['opsworks-utils']['alarms']['status-check-alarm']['threshold']
  statistic           node['opsworks-utils']['alarms']['status-check-alarm']['statistic']
  comparison_operator 'GreaterThanOrEqualToThreshold'
  metric_name         'StatusCheckFailed'
  namespace           'AWS/EC2'
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end
