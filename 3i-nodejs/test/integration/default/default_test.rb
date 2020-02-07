# # encoding: utf-8

# Inspec test for recipe 3i-nodejs::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/
describe package('nodejs') do
  it { should be_installed }
end

describe file('/usr/local/bin/node') do
  it { should exist }
  its('link_path') { should eq '/usr/bin/node' }
end
