class livereload {
  nodejs::npm { '/var/www:gulp-livereload':
    ensure  => present,
    install_opt => '--save-dev',
    require => Class['gulpjs']
  }
}