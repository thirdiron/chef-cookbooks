# Used to set up system wide .env include with 
# AWS Access key ID & corresponding secret key
template '/etc/s3.env' do
  source 's3.env.erb'
  cookbook '3i-server-commons'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :aws_access_key_id => node["s3-settings"]["aws-access-key-id"],
    :aws_secret_key => node["s3-settings"]["aws-secret-key"]
  )
end
