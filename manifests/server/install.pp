# nagios::server::install
#
# Private class to manage installing nagios server packages
#
# @summary Private class to install nagios
#
class nagios::server::install inherits nagios::server {

  $server_package        = $nagios::server_package
  $server_package_ensure = $nagios::server_package_ensure

  package { 'nagios_package':
    ensure => $server_package_ensure,
    name   => $server_package,
  }

}
