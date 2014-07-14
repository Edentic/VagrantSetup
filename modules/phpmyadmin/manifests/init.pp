# Class: phpmyadmin
#
#   This class installs phpmyadmin software.
#
class phpmyadmin::install {
  package { "phpmyadmin" :
    ensure => present,
    require => Class["mysql", "php", "apache"],
  }
}

class phpmyadmin::config {
  file { "a2en_phpmyadmin":
    name    => "/etc/apache2/sites-enabled/phpmyadmin.conf",
    ensure  => link,
    target  => "/etc/phpmyadmin/apache.conf",
    notify  => Class["apache::service"],
    require => Class["phpmyadmin::install"],
  }
}

class phpmyadmin {
  include phpmyadmin::install, phpmyadmin::config
}