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
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class bacula::filedaemon
(
    $director_name,
    $monitor_name,
    $pwd_for_director,
    $pwd_for_monitor,
    $bind_address='',
    $tls_enable='no',
    $backup_files,
    $use_puppet_certs='yes'
)
{

    if ( $use_puppet_certs == 'yes' ) and ( $tls_enable == 'yes' ) {
        include bacula::puppetcerts
    }

    include bacula::common
    include bacula::filedaemon::install

    class { 'bacula::filedaemon::config':
        director_name => $director_name,
        monitor_name => $monitor_name,
        pwd_for_director => $pwd_for_director,
        pwd_for_monitor => $pwd_for_monitor,
        bind_address => $bind_address,
        tls_enable => $tls_enable,
        backup_files => $backup_files,
    }

    include bacula::filedaemon::service

    if tagged('packetfilter') {
        include bacula::filedaemon::packetfilter
    }

    # This class will have to be included, or this node won't be able to export 
    # firewall resources to the Bacula Storagedaemon
    include bacula::filedaemon::export

    if tagged('monit') {
        include bacula::filedaemon::monit
    }

}
