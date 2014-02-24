Exec { path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"] }
# File { owner => 'root', group => 'root' }
group { "puppet": ensure => "present"}

import "settings"

# Ensure that packages are up to date before beginning.
exec { "apt-get update":
  command => "/usr/bin/apt-get update",
}
Package {
  require => Exec["apt-get update"]
}
File {
  require => Exec["apt-get update"]
}

include tools
include apache
include php
include mysql
include phpmyadmin

  class {'mailcatcher': }

  apache::vhost { 'edentic':
      port => '80',
      docroot => '/var/www',
      ssl => false,
      serveraliases => ['192.168.*.*', '192.168.57.10'],
      require => Class['apache']
  }
