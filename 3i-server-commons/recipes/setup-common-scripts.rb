cookbook_file '/usr/local/bin/beforeRotateLog.sh' do
  source 'beforeRotateLog.sh'
  mode '0755'
  owner 'root'
  group 'root'
end

# Script used to clean up old deployment folders
cookbook_file '/usr/local/bin/cleanup_old_releases.rb' do
  source 'cleanup_old_releases.rb'
  mode '0755'
  owner 'root'
  group 'root'
end
