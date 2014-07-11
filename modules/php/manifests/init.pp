# Class: php
#
#   This class installs php5.
#
class php::install {
  $packages = ["libapache2-mod-php5", "php5", "php5-cli", "php5-mysql", "php5-curl", "php5-dev", "php5-mcrypt", "php5-gd", "libpcre3-dev", "php5-fpm"]
  package { $packages:
    ensure => latest,
    require => Apt::Ppa['ppa:ondrej/php5']
  }
}

class php::config {
  file {
    "php_a2_ini":
      path    => "/etc/php5/apache2/php.ini",
      ensure  => present,
      source  => "puppet:///modules/php/php_a2.ini",
      owner   => 'root',
      group   => 'root',
      require => Package['php5', 'libapache2-mod-php5'],
      notify  => Class['apache::service'];

    "php_cli_ini":
      path    => "/etc/php5/cli/php.ini",
      ensure  => present,
      source  => "puppet:///modules/php/php_cli.ini",
      owner   => 'root',
      group   => 'root',
      require => Package['php5', 'php5-cli'];
  }
}

class php {
  include php::install, php::config
  include php::pear
}

