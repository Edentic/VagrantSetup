class gulpjs ($install_node = true) {

  if($install_node == true) {
    class {'nodejs' :
      manage_repo => true,
      version => 'latest'
    }
  }

  package { 'gulp':
    ensure   => present,
    provider => 'npm',
    require => Class['nodejs']
  }

  nodejs::npm { '/var/www:gulp':
    ensure  => present,
    install_opt => '--save-dev',
    require => Package['gulp']
  }
}