
# TODO: Parameterize the time zone info

case node[:platform]
when "ubuntu"

  execute 'timedatectl set-timezone America/New_York'

else
  # Amazon Linux specific http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
  # Also seems to work for Centos and RedHat
  file '/etc/sysconfig/clock' do
    content <<-EOH
      ZONE="America/New_York"
      UTC=true
    EOH
  end

  link '/etc/localtime' do
    to '/usr/share/zoneinfo/America/New_York'
  end
end



