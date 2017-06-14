git "/tmp/s3put" do
  repository 'git@github.com:thirdiron/s3put.git'
  reference 'v0.1'
  user 'ubuntu'
  action :sync
end

bash 'install_s3put' do
  cwd '/tmp/s3put'
  user 'root'
  group 'root'
  code <<-EOH
    make install
    EOH
end
