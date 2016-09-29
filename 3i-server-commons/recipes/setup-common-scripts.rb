cookbook_file '/usr/local/bin/beforeRotateLog.sh' do
  source 'beforeRotateLog.sh'
  mode '0755'
  owner 'root'
  group 'root'
end
