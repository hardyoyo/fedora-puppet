# Configuration for librarian-puppet (http://librarian-puppet.com/)
# This installs necessary third-party Puppet Modules for us.

# let's use PuppetForge for our puppet modules, shall we?
forge "http://forge.puppetlabs.com"

# the PuppetLabs stdlib module is a dependency for camptocamp/tomcat, and probably many other modules
mod "puppetlabs/stdlib"

# and let's just make vim a little nicer, because we can
mod "saz/vim"

# let's use camptocamp's tomcat module
mod "camptocamp/tomcat"

# let's get fancy with camptocamp's apache integration
mod "camptocamp/apache_c2c",
   :git => "git://github.com/camptocamp/puppet-apache_c2c.git"
