stack = search('aws_opsworks_stack').first
region = stack['region']
# instance = search('aws_opsworks_instance', 'self:true').first

### SSM Agent

case node[:platform]
when 'amazon'
  ssmagent_remote_file = 'amazon-ssm-agent.rpm'
  ssmagent_source = "https://amazon-ssm-#{region}.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm"
when 'redhat'
  ssmagent_remote_file = 'amazon-ssm-agent.rpm'
  ssmagent_source = "https://amazon-ssm-#{region}.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm"
when 'ubuntu'
  ssmagent_remote_file = 'amazon-ssm-agent.deb'
  ssmagent_source = "https://amazon-ssm-#{region}.s3.amazonaws.com/latest/debian_amd64/amazon-ssm-agent.deb"
when 'suse'
  ssmagent_remote_file = 'amazon-ssm-agent.rpm'
  ssmagent_source = "https://amazon-ssm-#{region}.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm"
else
  ssmagent_remote_file = 'amazon-ssm-agent.rpm'
  ssmagent_source = "https://amazon-ssm-#{region}.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{ssmagent_remote_file}" do
  source ssmagent_source
  action :create_if_missing
end

case node[:platform]
when 'amazon'
  rpm_package 'ssm-agent' do
    source "#{Chef::Config[:file_cache_path]}/#{ssmagent_remote_file}"
    not_if 'rpm -qa | grep ssm'
  end
when 'redhat'
  rpm_package 'ssm-agent' do
    source "#{Chef::Config[:file_cache_path]}/#{ssmagent_remote_file}"
    not_if 'rpm -qa | grep ssm'
  end
when 'ubuntu'
  dpkg_package 'ssm-agent' do
    source "#{Chef::Config[:file_cache_path]}/#{ssmagent_remote_file}"
    not_if 'dpkg -s ssm || snap list amazon-ssm-agent'
    # short term fix for failures due to change in ssm installation on Ubuntu 16.04+
    # https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-manual-agent-install.html#agent-install-ubuntu-snap
    # ignore_failure true
  end
when 'suse'
  zypper_package 'ssm-agent' do
    source "#{Chef::Config[:file_cache_path]}/#{ssmagent_remote_file}"
    not_if 'rpm -qa | grep ssm'
  end
else
  rpm_package 'ssm-agent' do
    source "#{Chef::Config[:file_cache_path]}/#{ssmagent_remote_file}"
    not_if 'rpm -qa | grep ssm'
  end
end

### AWS Inspector Agent

remote_file "#{Chef::Config[:file_cache_path]}/inspector-agent-installer" do
  source 'https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install'
  action :create_if_missing
  not_if { ::File.exist?('/opt/aws/awsagent/bin/awsagent') }
end

# For some reason, setting mode and owner in the
# remote_file resource isn't working. Do it here instead.
file "#{Chef::Config[:file_cache_path]}/inspector-agent-installer" do
  mode '0755'
  owner 'root'
  group 'root'
  not_if { ::File.exist?('/opt/aws/awsagent/bin/awsagent') }
end

execute "#{Chef::Config[:file_cache_path]}/inspector-agent-installer" do
  action :run
  not_if { ::File.exist?('/opt/aws/awsagent/bin/awsagent') }
end

# Packages for custom metrics monitoring
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html#mon-scripts-getstarted
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html
case node[:platform]
when 'amazon'
  package 'perl-Switch'
  package 'perl-DateTime'
  package 'perl-Sys-Syslog'
  package 'perl-LWP-Protocol-https'
when 'redhat'
  package 'perl-DateTime'
  package 'perl-Digest-SHA'
  package 'zip'
  package 'unzip'
  if node[:platform_version].start_with?('7.')
    package 'perl-Switch' do
      options '--enablerepo=rhui-REGION-rhel-server-optional'
    end
    package 'perl-Sys-Syslog'
    package 'perl-LWP-Protocol-https'
  else
    package 'perl-CPAN'
    package 'perl-Net-SSLeay'
    package 'perl-IO-Socket-SSL'
    package 'gcc'
  end
when 'centos'
  package 'perl-Switch'
  package 'perl-DateTime'
  package 'perl-Sys-Syslog'
  package 'perl-LWP-Protocol-https'
  package 'perl-Digest-SHA'
  package 'zip'
  package 'unzip'
when 'ubuntu'
  package 'unzip'
  package 'libwww-perl'
  package 'libdatetime-perl'
when 'suse'
  package 'perl-Switch'
  package 'perl-DateTime'
  package 'perl-LWP-Protocol-https'
else
  package 'perl-Switch'
  package 'perl-DateTime'
  package 'perl-Sys-Syslog'
  package 'perl-LWP-Protocol-https'
end

execute 'install-metrics-script' do
  user 'root'
  cwd '/root'
  command <<-EOH
    curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O && \
    unzip -o CloudWatchMonitoringScripts-1.2.2.zip && \
    rm -f CloudWatchMonitoringScripts-1.2.2.zip
  EOH
  not_if { ::File.exist?('/root/aws-scripts-mon/mon-put-instance-data.pl') }
end

disks = ''
node['opsworks-utils']['alarms']['disk-space-alarm']['targets'].each do |t|
  disks += ' --disk-path=' + t
end

cron 'custom-metrics-cron' do
  user 'root'
  minute '*/5'
  command "/root/aws-scripts-mon/mon-put-instance-data.pl --mem-util --swap-util --disk-space-util #{disks} --from-cron"
end
