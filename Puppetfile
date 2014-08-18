# Configuration for librarian-puppet (http://librarian-puppet.com/)
# This installs necessary third-party Puppet Modules for us.

# let's use PuppetForge for our puppet modules, shall we?
forge "http://forge.puppetlabs.com"

# the PuppetLabs stdlib and concat modules are dependencies for camptocamp modules, and probably many other modules
mod "puppetlabs/stdlib"
mod "puppetlabs/concat"

# and let's just make vim a little nicer, because we can
mod "saz/vim"

# let's use camptocamp's tomcat module
mod "camptocamp/tomcat"

# let's get fancy with camptocamp's apache integration
#mod "camptocamp/apache_c2c",
#   :git => "git://github.com/camptocamp/puppet-apache_c2c.git"
#

# let's just try soluvas/puppet-apache
mod "soluvas/puppet-apache"

# and we will deploy with this cool puppet-nexus module
mod "cescoffier/nexus",
   :git => "git://github.com/cescoffier/puppet-nexus.git"
