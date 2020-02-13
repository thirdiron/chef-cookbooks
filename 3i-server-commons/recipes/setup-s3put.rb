include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  git "/tmp/s3put" do
    repository 'https://github.com/thirdiron/s3put.git'
    reference 'v0.1'
    user 'root'
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

end
