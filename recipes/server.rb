

# server recipe

# execute sudo yum install java-1.7.0-openjdk-devel

package 'java-1.7.0-openjdk-devel'

user 'chef' do
	home '/home/chef'
end

user 'tomcat' do
	manage_home false
	home '/opt/tomcat'
end

group 'tomcat' do
	members 'tomcat'
	action :create
end

directory '/opt/tomcat' do
	action [:create]
	group 'tomcat'
	not_if do
		File.exist?('/opt/tomcat')
	end
end

# link in the lab instructions is dead - I found the distribution here:
# wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz  
#
# extract to /opt/tomcat
#
# only get the file if we don't already have it


remote_file '/opt/tomcat/apache-tomcat-8.0.33.tar.gz' do
	source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
	not_if do
		File.exist?('/opt/tomcat/apache-tomcat-8.0.33.tar.gz')
	end
end



#
# assume if the conf subdir exists, we've already untarred
#
execute 'tar -xvf /opt/tomcat/apache-tomcat-8.0.33.tar.gz -C /opt/tomcat --strip-components=1' do
	not_if do
		File.exist?('/opt/tomcat/conf')
	end
end


execute 'chgrp -R tomcat /opt/tomcat/conf' do
 	only_if { node['confGroupOK'] == 0 }
	node.override['confGroupOK'] = 1
end


execute 'chmod g+rwx /opt/tomcat/conf' do
 	only_if { node['confPermOK'] == 0 }
	node.override['confPermOK'] = 1

end


execute 'chmod g+r /opt/tomcat/conf/*' do
 	only_if { node['confPermAllOK'] == 0 }
	node.override['confPermAllOK'] = 1

end
 
execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs' do
 	only_if { node['dirOwnersOK'] == 0 }
	node.override['dirOwnersOK'] = 1
end


directory '/opt/tomcat/conf' do
  	mode '0755'
end

# template for the tomcat service file
# sudo vi /etc/systemd/system/tomcat.service

template '/etc/systemd/system/tomcat.service' do
	source 'tomcatService.erb'
   	notifies :restart, 'service[tomcat]',:immediate
end

# template for the tomcat server.xml file /opt/tomcat/conf/server.xml

# attr for tomcat-port in attributes\default.rb and used as node attr in
# server.xml template, and overridden by suites block in .kitchen.yml

template '/opt/tomcat/conf/server.xml' do
 	source 'tomcatServerXML.erb'
   	owner 'tomcat'
   	# notifies :run, 'execute[daemonReload]',:immediately
   	notifies :restart, 'service[tomcat]',:immediate
end

# execute 'systemctl daemon-reload'
execute 'daemonReload' do
	command 'systemctl daemon-reload'
	# action :nothing
end

# subscribes properties for state changes on tomcat.service and server.xml

service 'tomcat' do
	action [:start, :enable]
	subscribes :restart, 'template[/opt/tomcat/conf/server.xml]', :immediate
	subscribes :restart, 'template[/etc/systemd/system/tomcat.service]', :immediate
end





