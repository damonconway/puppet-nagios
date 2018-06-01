# Class: nagios
#
# Configures a host to be monitored by nagios.
#
# @summary install/configure a host for nagios monitoring
#
# @example
#   include nagios
#
# Parameters
# ----------
#
# * `config_d`
#   [Stdlib::Absolutepath] Path to main nagios config dir
#
# * `config_f`
#   [String] Name of main nagios config file (Default: OS dependent)
#
# * `config`
#   Optional[Hash] Options to set on the nagios_host resource
#
# * `file_per_resource`
#   [Boolean] If true, put all host related resources in individual files. If false, put all resources in a single file for the host. (Default: false).
#
# * `hostdependencies`
#   Optional[Hash] Hostdependencies and options to create as nagios_hostdependency resources
#
# * `hostescalations`
#   Optional[Hash] Hostescalations and options to create as nagios_hostdependency resources
#
# * `hostextinfo`
#   Optional[Hash] Hostextinfo and options to create as nagios_hostextinfo resources. Hostextinfo deprecated in Nagios 3.x.
#
# * `merge_config`
#   [Boolean] If true, use lookup to deep_merge all instances of the given Hashes. (Default: true)
#
# * `nrpe`
#   [Boolean] If true, install and configure nrpe on Unix hosts. (Default: $nagios::nrpe)
#
# * `ncsa`
#   [Boolean] If true, install and configure ncsa on Windows hosts. (Default: $nagios::ncsa)
#
# * `plugin_packages`
#   Optional[Hash] List of plugin packages to install.
#
# * `services`
#   Optional[Hash] List of services to monitor and options to pass to nagios_service
#
# * `servicedependencies`
#   Optional[Hash] Servicedependencies and options to create as nagios_servicedependency resources
#
# * `serviceescalations`
#   Optional[Hash] Serviceescalations and options to create as nagios_servicedependency resources
#
# * `serviceextinfo`
#   Optional[Hash] Serviceextinfo and options to create as nagios_serviceextinfo resources. Serviceextinfo deprecated in Nagios 3.x.
#
class nagios::client (
  Optional[Hash] $config              = undef,
  Boolean $file_per_resource          = false,
  Optional[Hash] $hostdependencies    = undef,
  Optional[Hash] $hostescalations     = undef,
  Optional[Hash] $hostextinfo         = undef,
  Boolean $merge_config               = true,
  Boolean $nrpe                       = true,
  Boolean $ncsa                       = true,
  Optional[Hash] $plugin_packages     = undef,
  Optional[Hash] $service_defaults    = undef,
  Optional[Hash] $services            = undef,
  Optional[Hash] $servicedependencies = undef,
  Optional[Hash] $serviceescalations  = undef,
  Optional[Hash] $serviceextinfo      = undef,
) {

  $hosts_d            = $nagios::server_hosts_d
  $server_config_d    = $nagios::server_config_d
  $server_config_f    = $nagios::server_config_f
  $target_file_prefix = "$server_config_d/$hosts_d/${::fqdn}"

  $_resource_defaults = $merge_config ? {
    false   => deep_merge({ 'notify' => Service['nagios_service'] }, $nagios::resource_defaults),
    default => deep_merge({ 'notify' => Service['nagios_service'] }, lookup('nagios::resource_defaults', Optional[Hash], 'deep', undef), $nagios::resource_defaults),
  }

  $_service_defaults = $merge_config ? {
    false   => $service_defaults,
    default => lookup('nagios::service_defaults', Optional[Hash], 'deep', undef),
  }

  $config_defaults = {
    host_name => $::hostname,
    address   => $::ipaddress,
    target    => "${target_file_prefix}.cfg",
  }

  $_config = $merge_config ? {
    false   => deep_merge($_resource_defaults, $config_defaults, $config),
    default => deep_merge($_resource_defaults, $config_defaults, lookup('nagios::client::config', Optional[Hash], 'deep', undef))
  }

  nagios_host { "nagios_${::fqdn}":
    * => $_config,
  }

  $_hostdependencies = $merge_config ? {
    false   => $hostdependencies,
    default => lookup('nagios::client::hostdependencies', Optional[Hash], 'deep', undef)
  }

  if $_hostdependencies {
    $_hostdependencies.each |$item,$opts| {
      $target_file = $file_per_resource ? {
        false   => "${target_file_prefix}.cfg",
        default => "${target_file_prefix}_${item}.cfg",
      }
      $generated_opts = {
        'target' => $target_file,
        'use'    => $item,
      }
      $params = deep_merge($_resource_defaults, $generated_opts, $opts)
      @@nagios_hostdependency { "${item}_${::fqdn}":
        * => $params,
      }
    }
  }

  $_hostescalations = $merge_config ? {
    false   => $hostescalations,
    default => lookup('nagios::client::hostescalations', Optional[Hash], 'deep', undef)
  }

  if $_hostescalations {
    $_hostescalations.each |$item,$opts| {
      $target_file = $file_per_resource ? {
        false   => "${target_file_prefix}.cfg",
        default => "${target_file_prefix}_${item}.cfg",
      }
      $generated_opts = {
        'target' => $target_file,
        'use'    => $item,
      }
      $params = deep_merge($_resource_defaults, $generated_opts, $opts)
      @@nagios_hostescalation { "${item}_${::fqdn}":
        * => $params,
      }
    }
  }

  $_hostextinfo = $merge_config ? {
    false   => $hostextinfo,
    default => lookup('nagios::client::hostextinfo', Optional[Hash], 'deep', undef)
  }

  if $_hostextinfo {
    $_hostextinfo.each |$item,$opts| {
      $target_file = $file_per_resource ? {
        false   => "${target_file_prefix}.cfg",
        default => "${target_file_prefix}_${item}.cfg",
      }
      $generated_opts = {
        'target' => $target_file,
        'use'    => $item,
      }
      $params = deep_merge($_resource_defaults, $generated_opts, $opts)
      @@nagios_hostextinfo { "${item}_${::fqdn}":
        * => $params,
      }
    }
  }

  $_services = $merge_config ? {
    false   => $services,
    default => lookup('nagios::client::services', Optional[Hash], 'deep', undef)
  }

  if $_services {
    $_services.each |$item,$opts| {
      $target_file = $file_per_resource ? {
        false   => "${target_file_prefix}.cfg",
        default => "${target_file_prefix}_${item}.cfg",
      }
      $generated_opts = {
        'target' => $target_file,
        'use'    => $item,
      }
      $params = deep_merge($_resource_defaults, $generated_opts, $opts)
      @@nagios_service { "${item}_${::fqdn}":
        * => $params,
      }
    }
  }

  $_servicedependencies = $merge_config ? {
    false   => $servicedependencies,
    default => lookup('nagios::client::servicedependencies', Optional[Hash], 'deep', undef)
  }

  if $_servicedependencies {
    $_servicedependencies.each |$item,$opts| {
      $target_file = $file_per_resource ? {
        false   => "${target_file_prefix}.cfg",
        default => "${target_file_prefix}_${item}.cfg",
      }
      $generated_opts = {
        'target' => $target_file,
        'use'    => $item,
      }
      $params = deep_merge($_resource_defaults, $generated_opts, $opts)
      @@nagios_servicedependency { "${item}_${::fqdn}":
        * => $params,
      }
    }
  }

  $_serviceescalations = $merge_config ? {
    false   => $serviceescalations,
    default => lookup('nagios::client::serviceescalations', Optional[Hash], 'deep', undef)
  }

  if $_serviceescalations {
    $_serviceescalations.each |$item,$opts| {
      $target_file = $file_per_resource ? {
        false   => "${target_file_prefix}.cfg",
        default => "${target_file_prefix}_${item}.cfg",
      }
      $generated_opts = {
        'target' => $target_file,
        'use'    => $item,
      }
      $params = deep_merge($_resource_defaults, $generated_opts, $opts)
      @@nagios_serviceescalation { "${item}_${::fqdn}":
        * => $params,
      }
    }
  }

  $_serviceextinfo = $merge_config ? {
    false   => $serviceextinfo,
    default => lookup('nagios::client::serviceextinfo', Optional[Hash], 'deep', undef)
  }

  if $_serviceextinfo {
    $_serviceextinfo.each |$item,$opts| {
      $target_file = $file_per_resource ? {
        false   => "${target_file_prefix}.cfg",
        default => "${target_file_prefix}_${item}.cfg",
      }
      $generated_opts = {
        'target' => $target_file,
        'use'    => $item,
      }
      $params = deep_merge($_resource_defaults, $generated_opts, $opts)
      @@nagios_serviceextinfo { "${item}_${::fqdn}":
        * => $params,
      }
    }
  }

}
