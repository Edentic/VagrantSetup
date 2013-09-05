# Define: php::pear::module
#
# Installs the defined php pear component.
#
# Parameters:
# - The $name
# - The $repository
# - The $version
#
# Sample Usage:
#  php::pear::module { 'drush':
#    repository => 'drush',
#    version => '4.6.0',
#  }
#
define php::pear::module($repository = "pear.php.net", $version = '') {

  include php::pear

  if $version {
    $package = "${repository}/${name}-${version}"
  }
  else {
    $package = "${repository}/${name}"
  }

  exec { "pear-${name}":
    command => "pear install ${package}",
    unless  => "pear info ${package}",
    require => Package["php-pear"],
  }
}