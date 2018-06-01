# nagios::server::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include nagios::server::config
class nagios::server::config {

  $config_d       = $nagios::server_config_d
  $config_f       = $nagios::server_config_f
  $merge_config   = $nagios::merge_config

  $_resource_defaults = $merge_config ? {
    false   => deep_merge({ 'notify' => Service['nagios_service'] }, $nagios::resource_defaults),
    default => deep_merge({ 'notify' => Service['nagios_service'] }, lookup('nagios::resource_defaults', Optional[Hash], 'deep', undef), $nagios::resource_defaults),
  }

  $_service_defaults = $merge_config ? {
    false   => $nagios::service_defaults,
    default => lookup('nagios::service_defaults', Optional[Hash], 'deep', undef),
  }

  $_cfg_path = { 'path' => "${config_d}/${config_f}" }
  $_cfg_defaults = $merge_config ? {
    false   => $_cfg_path,
    default => deep_merge($_cfg_path, lookup('naiogs::server::cfg_defaults', Optional[Hash], 'deep', undef),
  }

  $_config = $merge_config ? {
    false   => $config,
    default => lookup('nagios::server::config', Optional[Hash], 'deep', undef),
  }

  if $_config {
    $_config.each |$setting,$value| {
      if type($setting) =~ Type[Array] {
        $value.each |$val| {
          file_line { "nagios_cfg_${setting}_${val}":
            *       => $_cfg_defaults,
            line => "${setting}=${val}",
          }
        }
      } elsif type($value) =~ Type[String] {
        file_line { "nagios_cfg_${setting}":
          *    => $_cfg_defaults,
          line => "${setting}=${value}",
        }
      } else {
        warn('Settings must be an array or a string.')
      }
    }
  }

  $_commands = $merge_config ? {
    false   => $nagios::server::commands,
    default => lookup('nagios::server::commands', Optional[Hash], 'deep', undef),
  }

  if $_commands {
    $_commands.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_command { "nagios_command_${item}":
        * => $params,
      }
    }
  }

  $_contacts = $merge_config ? {
    false   => $nagios::server::contacts,
    default => lookup('nagios::server::contacts', Optional[Hash], 'deep', undef),
  }

  if $_contacts {
    $_contacts.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_contact { "nagios_contact_${item}":
        * => $params,
      }
    }
  }

  $_contactgroups = $merge_config ? {
    false   => $nagios::server::contactgroups,
    default => lookup('nagios::server::contactgroups', Optional[Hash], 'deep', undef),
  }

  if $_contactgroups {
    $_contactgroups.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_contactgroup { "nagios_contactgroup_${item}":
        * => $params,
      }
    }
  }

  $_hosts = $merge_config ? {
    false   => $nagios::server::hosts,
    default => lookup('nagios::server::hosts', Optional[Hash], 'deep', undef),
  }

  if $_hosts {
    $_hosts.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_host { "nagios_host_${item}":
        * => $params,
      }
    }
  }

  $_hostdependencies = $merge_config ? {
    false   => $nagios::server::hostdependencies,
    default => lookup('nagios::server::hostdependencies', Optional[Hash], 'deep', undef),
  }

  if $_hostdependencies {
    $_hostdependencies.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_hostdependency { "nagios_hostdependency_${item}":
        * => $params,
      }
    }
  }

  $_hostescalations = $merge_config ? {
    false   => $nagios::server::hostescalations,
    default => lookup('nagios::server::hostescalations', Optional[Hash], 'deep', undef),
  }

  if $_hostescalations {
    $_hostescalations.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_hostescalation { "nagios_hostescalation_${item}":
        * => $params,
      }
    }
  }

  $_hostextinfo = $merge_config ? {
    false   => $nagios::server::hostextinfo,
    default => lookup('nagios::server::hostextinfo', Optional[Hash], 'deep', undef),
  }

  if $_hostextinfo {
    $_hostextinfo.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_extinfo { "nagios_extinfo_${item}":
        * => $params,
      }
    }
  }

  $_hostgroups = $merge_config ? {
    false   => $nagios::server::hostgroups,
    default => lookup('nagios::server::hostgroups', Optional[Hash], 'deep', undef),
  }

  if $_hostgroups {
    $_hostgroups.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_hostgroup { "nagios_hostgroup_${item}":
        * => $params,
      }
    }
  }

  $_services = $merge_config ? {
    false   => $nagios::server::services,
    default => lookup('nagios::server::services', Optional[Hash], 'deep', undef),
  }

  if $_services {
    $_services.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $_service_defaults, $opts)
      @@nagios_service { "nagios_service_${item}":
        * => $params,
      }
    }
  }

  $_servicedependencies = $merge_config ? {
    false   => $nagios::server::servicedependencies,
    default => lookup('nagios::server::servicedependencies', Optional[Hash], 'deep', undef),
  }

  if $_servicedependencies {
    $_servicedependencies.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_servicedependency { "nagios_servicedependency_${item}":
        * => $params,
      }
    }
  }

  $_serviceescalations = $merge_config ? {
    false   => $nagios::server::serviceescalations,
    default => lookup('nagios::server::serviceescalations', Optional[Hash], 'deep', undef),
  }

  if $_serviceescalations {
    $_serviceescalations.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_serviceescalation { "nagios_serviceescalation_${item}":
        * => $params,
      }
    }
  }

  $_serviceextinfo = $merge_config ? {
    false   => $nagios::server::serviceextinfo,
    default => lookup('nagios::server::serviceextinfo', Optional[Hash], 'deep', undef),
  }

  if $_serviceextinfo {
    $_serviceextinfo.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_serviceextinfo { "nagios_serviceextinfo_${item}":
        * => $params,
      }
    }
  }

  $_servicegroups = $merge_config ? {
    false   => $nagios::server::servicegroups,
    default => lookup('nagios::server::servicegroups', Optional[Hash], 'deep', undef),
  }

  if $_servicegroups {
    $_servicegroups.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_servicegroup { "nagios_servicegroup_${item}":
        * => $params,
      }
    }
  }

  $_timeperiods = $merge_config ? {
    false   => $nagios::server::timeperiods,
    default => lookup('nagios::server::timeperiods', Optional[Hash], 'deep', undef),
  }

  if $_timeperiods {
    $_timeperiods.each |$item,$opts| {
      $params = deep_merge($_resource_defaults, $opts)
      @@nagios_timeperiod { "nagios_timeperiod_${item}":
        * => $params,
      }
    }
  }

}
