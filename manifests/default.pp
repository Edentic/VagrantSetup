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

  #Set up RUBY
  package {'build-essential':
    ensure => 'present'
  }

  package { 'g++':
    ensure => 'present'
  }

  class { 'ruby':
    ruby_package     => 'ruby1.9.1-full',
    rubygems_package => 'rubygems1.9.1',
    gems_version     => 'latest',
    require => [Package['build-essential'], Package['g++']]
  }

  #Install mailcatcher
  class { 'mailcatcher':
    require => Class['ruby']
  }

  #Setting up nodejs
  class {'nodejs' :
    manage_repo => true,
    version => 'latest'
  }

  #Setup apache
  apache::vhost { 'edentic':
      port => '80',
      docroot => '/var/www',
      ssl => false,
      serveraliases => ['192.168.*.*', '192.168.57.10'],
      require => Class['apache']
  }
