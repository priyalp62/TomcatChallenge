name 'TomcatChallenge'
maintainer 'Robert Statsinger'
maintainer_email 'rstatsinger@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures tomcat'
long_description 'Installs/Configures tomcat'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
#
#
issues_url 'https://github.com/rstatsinger/TomcatChallenge/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/tomcat'
#

source_url 'https://github.com/rstatsinger/TomcatChallenge'

supports 'centos'

depends 'tomcat'
