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
include apt

apt::ppa { 'ppa:ondrej/php5':

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
  if($install_node == true) {
      class {'nodejs' :
        manage_repo => true,
        version => 'latest'
      }
  }

  #Setting up gulpjs in dev enviroment
  if($install_node == true) and ($install_gulp == true) {
    class {'gulpjs':
      install_node => false,
      watch => $gulp_watch
   }
  }

  #Setting up livereload
  if($install_node == true) and ($install_gulp == true) and ($install_livereload == true) {
    class {'livereload': }
  }


  #Setup apache
  if($enginex == true) {

    apache::vhost { '000-default.conf':
      port => '8080',
      docroot => '/var/www',
      ssl => false,
      serveraliases => ['192.168.*.*', '192.168.57.10'],
      require => Class['apache']
    }

    class {'apache::portconfig':
      port => '8080'
    }

    class {'nginx':
      require => [Apache::Vhost['000-default.conf'], Class['apache::portconfig']]
    }

    nginx::resource::vhost { 'edentic':
      www_root => '/var/www',
      ensure => 'present',
      autoindex => 'off',
      try_files => ['$uri $uri/ /index.php?$query_string'],
      server_name => ['192.168.57.10', '192.168.*'],
      require => Class['php']
    }

    nginx::resource::location { "edentic_php":
      ensure          => present,
      ssl             => false,
      ssl_only        => false,
      vhost           => "edentic",
      www_root        => "/var/www",
      location        => '~ \.php$',
      index_files     => ['index.php', 'index.html', 'index.htm'],
      proxy           => undef,
      fastcgi         => 'unix:/var/run/php5-fpm.sock',
      fastcgi_script  => undef,
      location_cfg_append => {
        fastcgi_connect_timeout => '3m',
        fastcgi_read_timeout    => '3m',
        fastcgi_send_timeout    => '3m'
      },
  }

  nginx::resource::location { "edentic_deny":
    ensure          => present,
    www_root        => "/var/www",
    vhost           => "edentic",
    location        => '~ /\.ht',
    proxy           => undef,
    fastcgi_script  => undef,
    location_deny => ['all']
  }
} else {
    apache::vhost { 'edentic':
      port => '80',
      docroot => '/var/www',
      ssl => false,
      serveraliases => ['192.168.*.*', '192.168.57.10'],
      require => Class['apache']
    }
  }
