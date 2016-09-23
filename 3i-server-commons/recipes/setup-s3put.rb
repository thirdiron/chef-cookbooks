git "#{Chef::Config[:file_cache_path]}/s3put" do
  repository 'git@github.com:thirdiron/s3put.git'
  reference 'v0.1'
  user 'deploy'
  action :sync
end

bash 'install_s3put' do
  cwd '#{Chef::Config[:file_cache_path]}/s3put'
  user 'root'
  group 'root'
  code <<-EOH
    make install
    EOH
end
