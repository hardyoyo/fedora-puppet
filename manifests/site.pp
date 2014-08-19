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

# ensure tomcat6 is installed
package { "tomcat6":
  ensure => "installed"
}

->

# set authbind for tomcat6 (just append AUTHBIND=yes to the end of /etc/default/tomcat6)
exec {"setting AUTHBIND for tomcat6 to yes":
   command   => "echo 'AUTHBIND=yes' >> /etc/default/tomcat6",
   cwd       => "/etc/default",
   creates   => "/etc/default/tomcat6",
   logoutput => true,
}

->

# set up tomcat6's server.xml file
file { "/etc/tomcat6/settings.xml" :
   ensure  => file,
   owner   => tomcat6,
   group   => tomcat6,
   content => template("fedora/probe.xml.erb"),
}
 

# For convenience in troubleshooting Tomcat, let's install Psi-probe
exec {"Download and install the Psi-probe war":
   command   => "wget -q http://psi-probe.googlecode.com/files/probe-2.3.3.zip && unzip probe-2.3.3.zip && rm probe-2.3.3.zip",
   cwd       => "/var/lib/tomcat6/webapps",
   creates   => "/var/lib/tomcat6/webapps/probe.war",
   user      => "tomcat6",
   logoutput => true,
}

# add a context fragment file for Psi-probe
file { "/etc/tomcat6/Catalina/localhost/probe.xml" :
   ensure  => file,
   owner   => tomcat6,
   group   => tomcat6,
   content => template("fedora/probe.xml.erb"),
}
 
# finally, what we're here for, let's set up fedora4!

exec {"Download and install the Fedora4 war":
   command   => "wget -q https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.0.0-beta-01/fcrepo-webapp-4.0.0-beta-01.war -O fedora.war",
   cwd       => "/var/lib/tomcat6/webapps",
   creates   => "/var/lib/tomcat6/webapps/fedora.war",
   user      => "tomcat6",
   logoutput => true,
}

# add a context fragment file for Fedora
file { "/etc/tomcat6/Catalina/localhost/fedora.xml" :
   ensure  => file,
   owner   => tomcat6,
   group   => tomcat6,
   content => template("fedora/fedora.xml.erb"),
}

# reboot tomcat6
