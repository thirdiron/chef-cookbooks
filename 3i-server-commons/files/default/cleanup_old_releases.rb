#!/usr/local/bin/ruby -w

######
#
# Old releases cleanup script.  Pass in the absolute path to 
# an opsworks application's releases folder and it deletes
# releases we don't need anymore
#
######
require 'date'

releases_path = ARGV[0] 

release_folders = Dir[releases_path + '/*/'].sort!
release_folders.pop # Always keep latest release

release_folders.keep_if {
  |release|
  release_timestamp = File.basename(release)
  # delete deployments after 30 days
  cut_off_timestamp = (Date.today - 30).strftime('%Y%m%d%H%M%S')
  is_old = release_timestamp > cut_off_timestamp
  not is_old
}

release_folders.each do |old_release_dir|
  system("rm -r #{old_release_dir}")
end


