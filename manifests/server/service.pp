# nagios::server::service
#
# This private class manages the nagios server service.
#
# @summary Manage nagios service
#
class nagios::server::service {

  $nagios_service        = $nagios::nagios_service
  $nagios_service_ensure = $nagios::nagios_service_ensure

  service { 'nagios_service':
    ensure => $nagios_service_ensure,
    name   => $nagios_service,
  }

}
