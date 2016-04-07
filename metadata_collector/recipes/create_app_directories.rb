# Directories for metadata collector
directory '/var/log/metadata_collector' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

directory '/var/log/metadata_collector/ManualPulls' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

directory '/var/log/metadata_collector/DailyPulls' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

directory '/home/ubuntu/metadata_collector' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

# Directories for bzsales_reports
directory '/var/log/bzsales_reports' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

