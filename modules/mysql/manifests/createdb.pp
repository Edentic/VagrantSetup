# Definition: mysql::ceratedb
#
#   This class created mysql database.
#
# Parameters:
# - The $name of the database
# - The $user
# - The $password
#
# Sample Usage:
# mysql::createdb {"table": user => "myuser", password => "secret" }
#
define mysql::createddb( $user, $password ) {
  exec { "create-${name}-db":
    unless => "mysql -u${user} -p${password} ${name}",
    command => "mysql -uroot -p$mysql_password -e \"create database ${name}; grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
    require => Class[mysql::install],
  }
}


