# Class: mysql
#
#   This class installs mysql.
#
class mysql::install {
  $packages = ["mysql-server", "mysql-common", "mysql-client", "mytop"]
  package { $packages:
    ensure => present,
  }

  service { "mysql":
    enable => true,
    ensure => running,
    require => Package["mysql-server"],
  }
}

class mysql::config {
  exec { "set-mysql-password":
    unless  => "mysqladmin -uroot -p$mysql_password status",
    command => "mysqladmin -uroot password $mysql_password",
    require => Class["mysql::install"],
  }

  exec { "create-db":
    unless => "mysql -uroot -p$mysql_password $mysql_database",
    command => "mysql -uroot -p$mysql_password  -e 'create database $mysql_database'",
    require => Exec["set-mysql-password"],
    returns => [0]
  }
}

class mysql {
  include mysql::install, mysql::config
}