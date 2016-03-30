
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
    subnet_id = 'subnet-283b7e15'

    # First check whether we need to do anything
    check_command = "ifconfig -a | grep eth1 2>&1"
    interface_check_shell = Mixlib::ShellOut.new(check_command)
    interface_check_shell.run_command

    if !interface_check_shell.exitstatus then
      Chef::Log.fatal('Attempt to detect network adapter failed')
      raise "command failed: " + shell.stdout
    end

    if interface_check_shell.exitstatus == 1 then
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

      node["3i-mc"]["interface_id"] = interface_id
      node["3i-mc"]["assigned_private_ip"] = assigned_private_ip

      attach_command = "aws --region #{region} ec2 attach-network-interface --network-interface-id #{interface_id} --instance-id #{node["opsworks"]["instance"]["aws_instance_id"]} --device-index 1"
      attach_shell = MixLib::ShellOut.new("#{attach_command} 2>&1")
      attach_shell.run_command

      if !attach_shell.exitstatus then
        Chef.Log.fatal('Attempt to attach network interface to instance failed')
        raise "#{attach_command} failed: " + attach_shell.stdout
      end

      attach_output = JSON.parse(attach_shell.stdout)


    end


  end
  notifies :run, 'execute[configure_interface]', :immediately
end

execute 'configure_interface' do
  command "ifconfig eth1 #{node['3i-mc']['assigned_private_ip']}"
  action :nothing
end

# Beats me why this doesn't work!!!
#ifconfig 'interface_behind_nat' do
#  device 'eth1'
#  target lazy { node["3i-mc"]["assigned_private_ip"] }
#  onboot 'true'
#end
