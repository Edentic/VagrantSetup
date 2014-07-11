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
  if($enginex == false) {
    service { "httpd":
      name       => apache2,
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    service { "httpd":
      name       => apache2,
      ensure     => stopped,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}

class apache::config {
  apache::module { "rewrite": }
}

class apache {
  include apache::install, apache::service, apache::config
}
