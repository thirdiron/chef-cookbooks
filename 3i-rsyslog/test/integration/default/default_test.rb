# # encoding: utf-8

# Inspec test for recipe 3i-rsyslog::setup

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/
describe package('rsyslog') do
  it { should be_installed }
  its('version') { should_not match(/ubuntu/) }
  its('version') { should match(/adiscon/) }
end

describe package('tmpreaper') do
  it { should be_installed }
end

describe group('www-data') do
  its('members') { should include 'syslog' }
end
