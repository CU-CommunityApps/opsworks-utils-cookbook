# This recipe sets SELINUX to "permissive" mode.
# It is NOT run by default in hook-setup recipe.

# See https://linuxize.com/post/how-to-disable-selinux-on-centos-7/

# If setting SELINUX to permissive, one probably should start looking at
# its logs in /var/log/audit

ruby_block 'se-linux-permissive' do
  block do
    file = Chef::Util::FileEdit.new('/etc/selinux/config')
    # Handle a couple different scenarios
    file.search_file_replace_line('SELINUX=enforcing', "SELINUX=#{node['opsworks-utils']['selinux']['mode']}")
    file.search_file_replace_line('SELINUX=permissive', "SELINUX=#{node['opsworks-utils']['selinux']['mode']}")
    file.search_file_replace_line('SELINUX=disabled', "SELINUX=#{node['opsworks-utils']['selinux']['mode']}")
    file.insert_line_if_no_match("SELINUX=#{node['opsworks-utils']['selinux']['mode']}", "SELINUX=#{node['opsworks-utils']['selinux']['mode']}")
    file.write_file
  end
  notifies :request_reboot, 'reboot[reboot-after-se-linux-change]'
  only_if { node['opsworks-utils']['selinux']['set-mode'] }
end

reboot 'reboot-after-se-linux-change' do
  action :nothing
  reason 'Reboot after disabling SE Linux'
end
