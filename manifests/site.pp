# DSpace initialization script
#
# This Puppet script does the following:
# - installs Java, Maven, Ant
# - installs Git & clones DSpace source code
#

# Global default to requiring all packages be installed & apt-update to be run first
Package {
  ensure => latest,                # requires latest version of each package to be installed
  require => Exec["apt-get-update"],
}

# Ensure the rcconf package is installed, we'll use it later to set runlevels of services
package { "rcconf":
  ensure => "installed"
}

# Global default path settings for all 'exec' commands
Exec {
  path => "/usr/bin:/usr/sbin:/bin",
}

include tomcat

# Create a new Tomcat instance
#TODO: figure out how the Tomcat puppet module works for system-based installs (not in a user folder)
#TODO: use a different tomcat module, so this will be different
tomcat::instance { 'fedora4':
   owner   => "fedora",
   appBase => "/home/vagrant/dspace/webapps", # Tell Tomcat to load webapps from this directory
   ensure  => present,
}

->

# TODO: figure out the correct path for tomcat webaps
# For convenience in troubleshooting Tomcat, let's install Psi-probe
exec {"Download and install the Psi-probe war":
   command   => "wget http://psi-probe.googlecode.com/files/probe-2.3.3.zip && unzip probe-2.3.3.zip && rm probe-2.3.3.zip",
   cwd       => "/home/vagrant/tomcat/webapps",
   creates   => "/home/vagrant/tomcat/webapps/probe.war",
   user      => "vagrant",
   logoutput => true,
}
 
->
 
# Set the runlevels of tomcat7
# AND start the tomcat7 service
service {"tomcat7":
   enable => "true",
   ensure => "running",
}

->

# TODO: set the correct path for webapps, once I figure it out for probe, do the same for Fedora
# add a context fragment file for Psi-probe, and restart tomcat7
file { "/home/vagrant/tomcat/conf/Catalina/localhost/probe.xml" :
   ensure  => file,
   owner   => tomcat,
   group   => tomcat,
   content => template("fedora/probe.xml.erb"),
}