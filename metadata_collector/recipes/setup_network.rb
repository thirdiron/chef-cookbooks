
include_recipe 'apt'

apt_package 'awscli'

# Don't need to configure the cli because
# opsworks already puts credentials from
# the IAM role assigned to the instance
# in the right place for awscli to just use them


ruby_block 'ensure_interface_for_integration_traffic' do
  block do
    require 'json'

    region = 'us-east-1'
    subnet_id = node['3i_mc']['private_subnet_id']

    # First check whether we need to do anything
    check_command = "ifconfig -a | grep eth1 2>&1"
    interface_check_shell = Mixlib::ShellOut.new(check_command)
    interface_check_shell.run_command

    if !interface_check_shell.exitstatus then
      Chef::Log.fatal('Attempt to detect network adapter failed')
      raise "command failed: " + shell.stdout
    end

    if interface_check_shell.exitstatus == 0 then
      Chef::Log.info("Network adapter already attached and configured")
      next
    else
      create_command = "aws --region #{region} ec2 create-network-interface --subnet-id #{subnet_id} --output json"
      create_shell = Mixlib::ShellOut.new("#{create_command} 2>&1")
      create_shell.run_command

      if !create_shell.exitstatus then
        Chef.Log.fatal('Attempt to create network interface failed')
        raise "#{create_command} failed: " + shell.stdout
      end

      create_output = JSON.parse(create_shell.stdout)
      interface_id = create_output["NetworkInterface"]["NetworkInterfaceId"]
      assigned_private_ip = create_output["NetworkInterface"]["PrivateIpAddress"]

      node.override["3i_mc"]["interface_id"] = interface_id
      node.override["3i_mc"]["assigned_private_ip"] = assigned_private_ip

      attach_command = "aws --region #{region} ec2 attach-network-interface --network-interface-id #{interface_id} --instance-id #{node["opsworks"]["instance"]["aws_instance_id"]} --device-index 1"
      attach_shell = Mixlib::ShellOut.new("#{attach_command} 2>&1")
      attach_shell.run_command

      if !attach_shell.exitstatus then
        Chef::Log.fatal('Attempt to attach network interface to instance failed')
        raise "#{attach_command} failed: " + attach_shell.stdout
      end

      attach_output = JSON.parse(attach_shell.stdout)

#      configure_interface_command = "ifconfig eth1 #{assigned_private_ip}"
#      configure_interface_shell = Mixlib::ShellOut.new("#{configure_interface_command} 2>&1")
#      Chef::Log.debug("Running configure command: #{configure_interface_command}")
#      configure_interface_shell.run_command
#
#      if !configure_interface_shell.exitstatus || configure_interface_shell.exitstatus == 1 then
#        Chef::Log.fatal('Attempt to configure interface failed')
#        raise "#{configure_interface_command} : " + configure_interface_shell.stdout
#      end
#      Chef::Log.debug("Configure command output:" + configure_interface_shell.stdout)


    end


  end
end

template '/etc/network/interfaces.d/eth1.cfg' do
  source 'eth1.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'ifup' do
  command 'ifup eth1'
end

template '/etc/iproute2/rt_tables' do
  source 'rt_tables.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

bash 'eth1_routing' do
  code lazy { <<-SCRIPT
    echo "ip route add default via #{node['3i_mc']['private_subnet_gateway']} dev eth1 table nat"
    ip route add default via #{node['3i_mc']['private_subnet_gateway']} dev eth1 table nat
    ip rule add from #{node['3i_mc']['assigned_private_ip']}/32 table nat
    ip rule add to #{node['3i_mc']['assigned_private_ip']}/32 table nat
    ip route flush cache
    SCRIPT
  }
  user 'root'
end






# Beats me why this doesn't work!!!
#ifconfig 'interface_behind_nat' do
#  device 'eth1'
#  target lazy { node["3i_mc"]["assigned_private_ip"] }
#  onboot 'true'
#end
