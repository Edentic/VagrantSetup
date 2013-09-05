# Class: apc
#
#   This class installs apc.
#
class apc::install {
  package { "php-apc" :
    ensure => present,
    require => Class["php", "apache"],
  }
}

class apc::config {
  file {
    "apc.ini":
      path    => "/etc/php5/apache2/conf.d/apc.ini",
      content => template('apc/apc.ini.erb'),
      ensure  => present,
      notify  => Class['apache::service'],
      require => Class['apc::install'];
  }
}

class apc::admin {
  file {
    "apc.php":
      path    => "${apc::params::apc_admin_dir}/apc.php",
      ensure  => present,
      content => template('apc/apc.php.erb'),
      owner   => 'root',
      group   => 'root',
      notify  => Class["apache::service"],
      require => [Class["apc::config"], File["server_info_dir"]];

    "apc_admin_vhost" :
      path    => "/etc/apache2/sites-available/apc",
      content => template('apc/apc_apache_vhost.erb'),
      ensure  => present,
      owner   => "root",
      group   => "root",
      require => File["apc.php"];
  }

  exec { "sudo a2ensite apc" :
    notify  => Service["apache2"],
    unless  => "test -e /etc/apache2/sites-enabled/apc",
    require => File["apc_admin_vhost"];
  }
}

class apc {
  include php
  include apc::params
  include apc::install, apc::config
  include apc::admin
}