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
  http_port => '8080',
}

->

# set up a reverse proxy for tomcat

apache::vhost { '_default':
  proxy_pass => [
    { 'path' => '/probe', 'url' => 'http://localhost:8009/probe' },
    { 'path' => '/fedora', 'url' => 'http://localhost:8009/fedora' },
  ],
}


->


# TODO: set up tomcat-users.xml

# For convenience in troubleshooting Tomcat, let's install Psi-probe
exec {"Download and install the Psi-probe war":
   command   => "wget http://psi-probe.googlecode.com/files/probe-2.3.3.zip && unzip probe-2.3.3.zip && rm probe-2.3.3.zip",
   cwd       => "/srv/tomcat/fedora/webapps",
   creates   => "/srv/tomcat/fedora/webapps/probe.war",
   user      => "tomcat",
   logoutput => true,
}
 
#->

# TODO: finally, what we're here for, let's set up fedora4!

# Set the runlevels of tomcat-fedora
# AND start the tomcat-fedora service
#service {"tomcat-fedora":
#   enable => "true",
#   ensure => "running",
#}

