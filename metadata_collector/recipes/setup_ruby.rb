# The default version of rubygems isn't particularly smart
# about choosing versions of dependencies when the latest
# doesn't work in the installed version of ruby.
# Instead of picking the latest that works, it exits with an
# error complaining the latest doesn't work with the installed
# version of ruby.  
# Apparently this was resolved in RubyGems 2.3.0, so we update
# rubygems during machine setup

execute 'install_updater_gem' do
  command 'gem install rubygems-update'
  user 'root'
end

execute 'update_rubygems' do
  command 'update_rubygems'
  user 'root'
end
