# Class: pear
#
#   This class installs php pear.
#
class php::pear::install {

  package { "php-pear":
    ensure => present,
    require => Package['php5'],
  }
}

class php::pear {
  	include php
  	include php::pear::install
}