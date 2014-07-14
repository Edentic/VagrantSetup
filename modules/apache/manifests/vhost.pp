# Definition: apache::vhost
#
#   This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $template option specifies whether to use the default template or override
# - The $serveraliases of the site
#
# Sample Usage:
#  apache::vhost { 'site.name.fqdn':
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
define apache::vhost(
  $port,
  $docroot,
  $ssl=true,
  $template='apache/vhost-default.conf.erb',
  $serveraliases = ''
  ) {

  file {
    "vhost_${name}":
      path    => "/etc/apache2/sites-available/${name}.conf",
      ensure => 'present',
      content => template($template),
      mode    => '644',
      owner => 'root',
      group => 'root',
      require => Package['httpd'],
      notify  => Service['httpd'];

    "docroot_${name}":
      path    => $docroot,
      ensure => "directory",
      recurse => true,
      require => File["vhost_${name}"];
  }

  exec { "enable_apache_vhost" :
    command => "sudo a2ensite ${name}",
    notify  => Service["apache2"],
     unless  => "test -e /etc/apache2/sites-enabled/${name}.conf",
    require => File["vhost_${name}"];
  }

}
