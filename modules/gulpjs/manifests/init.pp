class gulpjs ($install_node = true, $watch = false) {

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

  if($watch == true) {
      exec {'gulp watch':
        cwd => '/var/www',
        require => Nodejs::Npm['/var/www:gulp'],
        logoutput => true
      }
  }
}