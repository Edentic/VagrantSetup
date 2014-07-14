# Class: apache
#
#   This class installs apache.
#
class apache::install {

  package { "httpd":
    name   => apache2,
    ensure => present,
  }
}

class apache::service {
    service { "httpd":
      name       => apache2,
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
}

class apache::config {
  apache::module { "rewrite": }
}

class apache::portconfig(
  $port = '80'
) {
  file {
    "apache_port" :
    path => '/etc/apache2/ports.conf',
    ensure => present,
    content => template('apache/ports.cfg.erb'),
    mode => '644',
    group => 'root',
    owner => 'root',
    require => Package['httpd'],
    notify  => Service['httpd']
  }
}

class apache {
  include apache::install, apache::service, apache::config
}
