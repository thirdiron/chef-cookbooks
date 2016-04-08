# We have to do this at the configure step instead of in
# app deploy because opsworks recipes obliterate users 
# every time configure happens

# Put ubuntu in the www-data group for easy log access
# but also so CLI commands can access application environments
group 'www-data' do
  append true
  members ['ubuntu']
  action :modify
end
