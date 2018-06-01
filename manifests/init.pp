# Class: nagios
#
# Configures a host to be monitored by nagios and/or setup nagios to monitor other systems.
#
# @summary install/configure a host for nagios monitoring
#
# @example
#   include nagios
#
# Parameters
# ----------
#
# * `client_setup`
#   [Boolean] If true, include nagios::client to setup host to be monitored by nagios. (Default: true)
#
# * `hosts_d`
#   [String] Name of dir relative to $server_config_d to hold target files for monitored resources. (Default: hosts)
#
# * `nagios_service`
#   [String] Name of the nagios service. (Default: OS dependent)
#
# * `nagios_service_ensure`
#   [String] String to pass to ensure for the nagios service. (Default: running)
#
# * `ncsa`
#   [Boolean] If true, install and configure ncsa on Windows hosts. (Default: true)
#
# * `nrpe`
#   [Boolean] If true, install and configure nrpe on Unix hosts. (Default: true)
#
# * `server_config_d`
#   [Stdlib::Absolutepath] Path to nagios server config dir. (Default: OS dependent)
#
# * `server_config_f`
#   [String] Filename of the server's main nagios config file. (Default: nagios.cfg)
#
# * `server_package`
#   [String] Name of the nagios package. (Default: OS dependent)
#
# * `server_package_ensure`
#   [String] String to pass to ensure for the nagios package. (Default: installed)
#
# * `server_setup`
#   [Boolean] If true, include nagios::server to setup host to be a nagios server. (Default: false)
#
class nagios (
  Boolean $client_setup                 = true,
  String $hosts_d                       = 'hosts',
  String $nagios_service                = $nagios::params::nagios_service,
  String $nagios_service_ensure         = 'running',
  Boolean $ncsa                         = true,
  Boolean $nrpe                         = true,
  Stdlib::Absolutepath $server_config_d = $nagios::params::server_config_d,
  String $server_config_f               = $nagios::params::server_config_f,
  String $server_package                = $nagios::params::server_package,
  String $server_package_ensure         = 'installed',
  Boolean $server_setup                 = false,
) inherits nagios::params {

  if $client_setup { include nagios::client }
  if $server_setup { include nagios::server }

}
