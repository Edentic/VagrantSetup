# Class: git
#
#   This class installs git and add a config file containing aliases and colors
#   definition.
#
class git::install {
  package { 'git-core':
    ensure => present;
  }
}

class git::config {
  file { "/home/${username}/.gitconfig":
    content => template('git/gitconfig.erb'),
    require => Class['git::install'],
  }
}

class git {
  include git::install, git::config
}