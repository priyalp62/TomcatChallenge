

# server recipe

# execute sudo yum install java-1.7.0-openjdk-devel

package 'java-1.7.0-openjdk-devel'

user 'tomcat' do
	manage_home false
	home '/opt/tomcat'
end

group 'tomcat' do
	members 'tomcat'
	action :create
end

# link in the lab instructions is dead - I found the distribution here:
# wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz  
#
# extract to /opt/tomcat
#
# sample war link ok
# https://github.com/johnfitzpatrick/certification-workshops/blob/master/Tomcat/sample.war


remote_file 'apache-tomcat-8.0.33.tar.gz' do
	source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
end

directory '/opt/tomcat' do
	action [:create]
	group 'tomcat'
end


# TODO - make this stuff idempotent
#
execute 'tar -xvf apache-tomcat-8.0.33.tar.gz -C /opt/tomcat --strip-components=1'
execute 'chgrp -R tomcat /opt/tomcat/conf'
execute 'chmod g+rwx /opt/tomcat/conf'
execute 'chmod g+r /opt/tomcat/conf/*'

execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs'

# This one is idempotent - will have to revise the others

directory '/opt/tomcat/conf' do
	mode '0755'
end

# template for the tomcat service file
# sudo vi /etc/systemd/system/tomcat.service

template '/etc/systemd/system/tomcat.service' do
	source 'tomcatService.erb'
end

# template for the tomcat server.xml file /opt/tomcat/conf/server.xml

# default attr for listenerPort in attributes\default.rb and used as node attr in
# server.xml template

template '/opt/tomcat/conf/server.xml' do
 	source 'tomcatServerXML.erb'
#   	variables(
#   		:listenerPort => node['tomcat']['listenerPort']
#   	)
   	owner 'tomcat'
   	# notifies :run, 'execute[daemonReload]',:immediately
   	notifies :restart, 'service[tomcat]',:immediately
   end

# execute 'systemctl daemon-reload'
execute 'daemonReload' do
	command 'systemctl daemon-reload'
	# action :nothing
end

service 'tomcat' do
	action [:start, :enable]
end




