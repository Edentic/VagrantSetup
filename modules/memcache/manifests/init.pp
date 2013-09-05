# Class: memcache
#
#   This class installs memcache.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class memcache::install {


# 1) sudo apt-get install php5-memcached
  package {'memcached':
    ensure => present,
  }

  service { 'memcached':
    enable => true,
    ensure => running,
    require => Package['memcached']
  }
}

class memcache {
  include memcache::install
}