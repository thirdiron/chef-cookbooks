include_recipe 'slack'

node[:deploy].each do |application, deploy|

  slack_say "This sent a message!" # eventually "#{application} deployed!"

end

