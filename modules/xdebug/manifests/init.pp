# Class: xdebug
#
#   This class installs xdebug.
#
class xdebug::install {
  php::pear::module { "xdebug":
    repository => "pecl",
    require => Class['php'],
  }
}

class xdebug::config {
  file { "xdebug_ini":
    path => "/etc/php5/conf.d/xdebug.ini",
    content => template('xdebug/xdebug.erb'),
    ensure => present,
    owner => 'root',
    group => 'root',
    require => Class['xdebug::install'];
  }
}

class xdebug {
  include xdebug::install, xdebug::config
}