# Class: nagios::server
#
# Installs and configures a nagios server on a system. It will use the default
# config as provided by the package.
#
# @summary install/configure a nagios server
#
# @example
#   include nagios::server
#
# Parameters
# ----------
#
# * `commands`
#   Optional[Hash] Commands and options to create as nagios_command resources
#
# * `config_d`
#   [Stdlib::Absolutepath] Path to main nagios config dir
#
# * `config_f`
#   [String] Name of main nagios config file (Default: OS dependent)
#
# * `commands`
#   Optional[Hash] Contacts and options to create as nagios_command resources
#
# * `contacts`
#   Optional[Hash] Contacts and options to create as nagios_contact resources
#
# * `contactgroups`
#   Optional[Hash] Contactgroups and options to create as nagios_contactgroup resources
#
# * `config`
#   Optional[Hash] List of config options to set in $config_f. If value is an Array, do multiple instances of the key. If value is a Hash, pass as options to file_line.
#
# * `hostdependencies`
#   Optional[Hash] Hostdependencies and options to create as nagios_hostdependency resources
#
# * `hostescalations`
#   Optional[Hash] Hostescalations and options to create as nagios_hostdependency resources
#
# * `hostextinfo`
#   Optional[Hash] Hostextinfo and options to create as nagios_extinfo resources
#
# * `hostgroups`
#   Optional[Hash] Hostgroups and options to create as nagios_hostgroup resources
#
# * `merge_config`
#   [Boolean] If true, use lookup to deep_merge all instances of the given Hashes.
#
# * `services`
#   Optional[Hash] List of services and/or service templates
#
class nagios::server (
  Optional[Hash] $commands            = undef,
  Optional[Hash] $contacts            = undef,
  Optional[Hash] $contactgroups       = undef,
  Optional[Hash] $config              = undef,
  Optional[Hash] $hosts               = undef,
  Optional[Hash] $hostdependencies    = undef,
  Optional[Hash] $hostescalations     = undef,
  Optional[Hash] $hostextinfo         = undef,
  Optional[Hash] $hostgroups          = undef,
  Optional[Hash] $services            = undef,
  Optional[Hash] $servicedependencies = undef,
  Optional[Hash] $serviceescalations  = undef,
  Optional[Hash] $serviceextinfo      = undef,
  Optional[Hash] $servicegroups       = undef,
  Optional[Hash] $timeperiods         = undef,
) {

  contain nagios::server::install
  contain nagios::server::config
  contain nagios::server::service

  Class['nagios::server::install']->
  Class['nagios::server::config']->
  Class['nagios::server::service']

}
