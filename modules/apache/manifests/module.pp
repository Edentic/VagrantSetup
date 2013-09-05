# Definition: apache::module
#
#   This class enable Apache module
#
# Parameters:
# - The $name of the module to install
#
# Sample Usage:
#  apache::module { "module_name": }
#
define apache::module () {
  exec { "/usr/sbin/a2enmod ${name}" :
  	unless  => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
  	require => Class[apache],
  	notify  => Class[apache::service],
  }
}