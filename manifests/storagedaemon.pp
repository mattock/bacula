#
# == Class: bacula::storagedaemon
#
# Setup Bacula Storagedaemon.
#
# FIXME: add support for creating $backup_directory with correct permissions.
#
# == Parameters
#
# [*manage*]
#   Whether to manage Bacula Storagedaemon with Puppet or not. Valid values are 
#   'yes' (default) and 'no'.
# [*director_address_ipv4*]
#   IP-address for incoming Bacula Director packets.
# [*director_name*]
#   Name of the Director allowed to contact this filedaemon
# [*monitor_name*]
#   Name of the Monitor allowed to contact this filedaemon
# [*pwd_for_director*]
#   Password for the Director that contacts this filedaemon
# [*pwd_for_monitor*]
#   Password for the Monitor that contacts this filedaemon
# [*bind_address*]
#   Bind to this IPv4 address. Empty by default.
# [*backup_directory*]
#   The directory where backups are stored. Defaults to '/var/backups/bacula'.
# [*tls_enable*]
#   Enable TLS. Defaults to 'no'.
# [*use_puppet_certs*]
#   Use puppet certs for TLS. Defaults to 'yes'.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to.
#   Defaults to global variable $::servermonitor.
# [*filedaemon_addresses_ipv4*]
#   An array of IPv4 address/networks from where to allow 
#   Filedaemon connections to the Storagedaemon
#
# == Examples
#
#   class { 'bacula::filedaemon':
#       director_name => 'backup.domain.com-dir',
#       director_address_ipv4 => '10.10.5.8',
#       monitor_name => 'management.domain.com-mon',
#       pwd_for_director => 'password',
#       pwd_for_monitor => 'password',
#       backup_directory => '/backup',
#       bind_address => '127.0.0.1',
#       tls_enable => 'yes',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class bacula::storagedaemon
(
    $manage = 'yes',
    $director_name,
    $director_address_ipv4,
    $monitor_name,
    $pwd_for_director,
    $pwd_for_monitor,
    $bind_address=undef,
    $backup_directory='/var/backups/bacula',
    $tls_enable='no',
    $use_puppet_certs='yes',
    $monitor_email=$::servermonitor,
    $filedaemon_addresses_ipv4
)
{

if $manage == 'yes' {

    if ( $use_puppet_certs == 'yes' ) and ( $tls_enable == 'yes' ) {
        include ::bacula::puppetcerts
    }

    include ::bacula::common
    include ::bacula::storagedaemon::install

    class { '::bacula::storagedaemon::config':
        director_name    => $director_name,
        monitor_name     => $monitor_name,
        pwd_for_director => $pwd_for_director,
        pwd_for_monitor  => $pwd_for_monitor,
        bind_address     => $bind_address,
        backup_directory => $backup_directory,
        tls_enable       => $tls_enable,
    }

    include ::bacula::storagedaemon::service

    if tagged('packetfilter') {
        class { '::bacula::storagedaemon::packetfilter':
            filedaemon_addresses_ipv4 => $filedaemon_addresses_ipv4,
            director_address_ipv4     => $director_address_ipv4,
        }
    }

    if tagged('monit') {
        class { '::bacula::storagedaemon::monit':
            monitor_email => $monitor_email,
        }
    }
}
}
