# Fedora4 initialization script
#
# This Puppet script does the following:
# - installs Tomcat
# - downloads and configures wars for probe and fedora4

# Ensure the rcconf package is installed, we'll use it later to set runlevels of services
package { "rcconf":
  ensure => "installed"
}

# Global default path settings for all 'exec' commands
Exec {
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin",
}

# Let's ensure Vim is properly configured
class { 'vim': }

# Create a new Tomcat instance
include tomcat

tomcat::instance {'fedora':
  ensure    => present,
  http_port => '80',
}


->

# TODO: figure out the correct path for tomcat webaps
# For convenience in troubleshooting Tomcat, let's install Psi-probe
#exec {"Download and install the Psi-probe war":
#   command   => "wget http://psi-probe.googlecode.com/files/probe-2.3.3.zip && unzip probe-2.3.3.zip && rm probe-2.3.3.zip",
#   cwd       => "/home/vagrant/tomcat/webapps",
#   creates   => "/home/vagrant/tomcat/webapps/probe.war",
#   user      => "vagrant",
#   logoutput => true,
#}
 
#->

#TODO I'm not sure what the service name will be... but tomcat7 is a good guess
# Set the runlevels of tomcat7
# AND start the tomcat7 service
#service {"tomcat7":
#   enable => "true",
#   ensure => "running",
#}

#->

# TODO: set the correct path for webapps, once I figure it out for probe, do the same for Fedora
# add a context fragment file for Psi-probe, and restart tomcat7
#file { "/home/vagrant/tomcat/conf/Catalina/localhost/probe.xml" :
#   ensure  => file,
#   owner   => tomcat,
#   group   => tomcat,
#   content => template("fedora/probe.xml.erb"),
#}
