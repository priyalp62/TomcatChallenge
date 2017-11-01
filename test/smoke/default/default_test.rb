# # encoding: utf-8

# Inspec test for recipe tomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

#unless os.windows?
  # This is an example test, replace with your own test.
#  describe user('root'), :skip do
#    it { should exist }
#  end
#end

# This is an example test, replace it with your own test.
#describe port(80), :skip do
#  it { should_not be_listening }
#end

describe command('curl http://localhost:8181') do
	its('stdout') { should match /Tomcat/ }
end

describe package('java-1.7.0-openjdk-devel') do
	it { should be_installed }
end

describe group('tomcat') do
	it { should exist }
end

# directories

describe directory('/opt/tomcat') do
	it { should exist }
end

describe directory('/opt/tomcat/conf') do
	it { should exist }
	its('mode') { should cmp '0755' }
end

%w[ webapps work temp logs ].each do |path|

	describe directory("/opt/tomcat/#{path}") do
		it { should exist }
		its('owner') { should eq 'tomcat' }
	end
end

# user

describe user('chef') do
	it { should exist }
end

describe user('tomcat') do
	it { should exist }
	its('groups') { should include 'tomcat' }
	its('home') { should eq '/opt/tomcat' }
end

describe file ('/etc/systemd/system/tomcat.service') do
	it { should exist }
end

# sshd config
#
describe sshd_config do
	its('PasswordAuthentication') { should eq 'yes' }
end 
