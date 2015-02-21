#
# == Class: bacula::filedaemon
#
# Setup Bacula Director daemon. The list of backed up machines is generated 
# dynamically from configuration file fragments exported by nodes that include 
# the bacula::filedaemon class. In other words, the filedaemon nodes add 
# themselves to the backup cycle.
#
# == Parameters
#
# [*manage*]
#   Manage Bacula Filedaemon using Puppet. Valid values 'yes' (default) and 
#   'no'.
# [*status*]
#   Status of the Bacula Filedaemon. Valid values are 'present' and 'absent'. 
#   Default value is 'present'. This is primary useful when decommissioning 
#   nodes to ensure that exported resources are cleaned up properly.
# [*package_name*]
#   Override the default package name obtained from params.pp. This is useful if 
#   your operating system provides two different bacula-fd/bacula-client 
#   versions under different names, e.g. for compatibility reasons. For example, 
#   on FreeBSD 10 you need to set this parameter to 'bacula5-client' to be able 
#   to connect to 5.2.x-based Directors and StorageDaemons.
# [*director_address_ipv4*]
#   IP-address for incoming Bacula Director packets. Defaults to 'auto', which 
#   means that the IP-address exported by the Director is used. In most cases 
#   this works, but when it doesn't, this parameter allow manual override.
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
# [*tls_enable*]
#   Enable TLS. Defaults to 'no'.
# [*use_puppet_certs*]
#   Use puppet certs for TLS. Defaults to 'yes'.
# [*backup_files*]
#   An array containing the list of directories/files to backup
# [*schedules*]
#   An array containing "Run" lines for a Filedaemon-specific schedule. Defaults 
#   to '' which means that the default Schedule called "default-schedule" 
#   defined in the bacula::director class is used.
# [*messages*]
#   Which messages should be sent via email. Use "All" for (almost) all messages 
#   and "AllButInformational" for everything except "Backup OK of <node>..." 
#   messages and like. Defaults to "All".
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to.
#   Defaults to global variable $::servermonitor.
#
# == Examples
#
#   class { 'bacula::filedaemon':
#     director_name => 'backup.domain.com-dir',
#     monitor_name => 'management.domain.com-mon',
#     pwd_for_director => 'password',
#     pwd_for_monitor => 'password',
#     bind_address => '0.0.0.0',
#     tls_enable => 'yes',
#     backup_files => [ '/etc', '/var/lib/puppet/ssl', '/var/backups/local' ],
#     schedules => ['Level=Full sun at 01:00',
#                   'Level=Incremental mon-sat at 01:00'],
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
class bacula::filedaemon
(
    $manage='yes',
    $status='present',
    $package_name=$::bacula::params::bacula_filedaemon_package,
    $director_address_ipv4='auto',
    $director_name,
    $monitor_name,
    $pwd_for_director,
    $pwd_for_monitor,
    $bind_address='',
    $tls_enable='no',
    $backup_files,
    $use_puppet_certs='yes',
    $schedules='',
    $messages='All',
    $monitor_email=$::servermonitor
) inherits bacula::params
{

if $manage == 'yes' {

    # Remove obsolete configurations
    include bacula::filedaemon::absent

    if ( $use_puppet_certs == 'yes' ) and ( $tls_enable == 'yes' ) {
        include bacula::puppetcerts
    }

    include bacula::common

    class { 'bacula::filedaemon::install':
        status => $status,
        package_name => $package_name,
    }

    class { 'bacula::filedaemon::config':
        status => $status,
        director_name => $director_name,
        monitor_name => $monitor_name,
        pwd_for_director => $pwd_for_director,
        pwd_for_monitor => $pwd_for_monitor,
        bind_address => $bind_address,
        tls_enable => $tls_enable,
        backup_files => $backup_files,
        schedules => $schedules,
        messages => $messages,
    }

    class { 'bacula::filedaemon::service':
        ensure => $status,
    }

    if tagged('packetfilter') {
        class { 'bacula::filedaemon::packetfilter':
            status => $status,
            director_address_ipv4 => $director_address_ipv4,
        }
    }

    # This class will have to be included, or this node won't be able to export 
    # firewall resources to the Bacula Storagedaemon
    class { 'bacula::filedaemon::export':
        status => $status,
    }

    if tagged('monit') {
        class { 'bacula::filedaemon::monit':
            status => $status,
            monitor_email => $monitor_email,
        }
    }
}
}
