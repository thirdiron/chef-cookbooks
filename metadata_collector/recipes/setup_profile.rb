directory '/home/ubuntu/profile.d' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

template '/home/ubuntu/.bash_profile' do
  source '.bash_profile.erb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0644'
end

template '/home/ubuntu/.bashrc' do
  source '.bashrc.erb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0644'
  variables ({
    :redis_password => node['3i_mc']['redis_password']
  })
end
