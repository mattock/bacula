#
# == Class: bacula::director
#
# Setup Bacula Director daemon.
#
# FIXME: for some reason granting privileges to the postgresql database tables 
# fails and has to be run manually. Tables are created without any issues. See 
# bacula::director::config::postgresql for details.
#
# == Parameters
#
# [*manage*]
#  Whether to manage Bacula Director with Puppet or not. Valid values are 'yes' 
#  (default) and 'no'.
# [*console_host*]
#   Allow console connections from this IPv4 address. Defaults to 127.0.0.1
# [*bind_address*]
#   Bind to this IPv4 address. Defaults to 127.0.0.1.
# [*pwd_for_console*]
#   Password used for console connections to this director
# [*pwd_for_monitor*] 
#   Password used for monitoring connections to this director
# [*sd_host*]
#   IPv4 address of the Bacula storage daemon host. Defaults to 127.0.0.1.
# [*sd_password*]
#   Password used to connect to the storage daemon
# [*postgresql_auth_line*]
#   Authentication details for postgresql in pg_hba.conf format
# [*bacula_db_password*]
#   Password for the bacula database user
# [*tls_enable*]
#   Enable TLS. Defaults to 'no'.
# [*use_puppet_certs*]
#   Use puppet certs for TLS. Defaults to 'yes'.
# [*default_schedules*]
#   An array of "Run" lines to add to the default schedule used by Filedaemons.
#   Each Filedaemon can override this schedule with their own using the
#   schedules parameter. By default the following two Run lines are used:
#
#   'Level=Full sun at 05:00',
#   'Level=Incremental mon-sat at 05:00'
#
# [*volume_retention*]
#   How long to retain volumes. Defaults to '365 days'.
# [*max_volume_bytes*]
#   Maximum volume size in bytes. Defaults to '5G'.
# [*max_volumes*]
#   Maximum number of volumes. Defaults to 100.
# [*email*]
#   Email address where Bacula's internal notifications are sent. Defaults to 
#   global variable $::servermonitor.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to.
#   Defaults to global variable $::servermonitor.
#
# == Examples
#
#   class { 'bacula::director':
#     console_host => 'management.domain.com',
#     pwd_for_console => 'password',
#     pwd_for_monitor => 'password',
#     sd_host => 'storagedaemon.domain.com',
#     sd_password => 'password',
#     postgresql_auth_line => 'local bacula baculauser  password',
#     bacula_db_password => 'password',
#     bind_address => '0.0.0.0',
#     tls_enable => 'yes',
#     email => 'backups@domain.com',
#     monitor_email => 'monit@domain.com',
#     max_volume_bytes => '5G',
#     max_volumes => 200,
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
class bacula::director(
    $manage = 'yes',
    $console_host='127.0.0.1',
    $bind_address='127.0.0.1',
    $pwd_for_console,
    $pwd_for_monitor,
    $sd_host='127.0.0.1',
    $sd_password,
    $postgresql_auth_line,
    $bacula_db_password,
    $tls_enable='no',
    $use_puppet_certs='yes',
    $default_schedules = ['Level=Full sun at 05:00',
                          'Level=Incremental mon-sat at 05:00'],
    $volume_retention = '365 days',
    $max_volume_bytes = '5G',
    $max_volumes = 100,
    $email = $::servermonitor,
    $monitor_email = $::servermonitor
)
{

if $manage == 'yes' {

    if ( $use_puppet_certs == 'yes' ) and ( $tls_enable == 'yes' ) {
        include ::bacula::puppetcerts
    }

    include ::bacula::common
    include ::bacula::director::install

    class { '::bacula::director::config':
        bind_address         => $bind_address,
        pwd_for_console      => $pwd_for_console,
        pwd_for_monitor      => $pwd_for_monitor,
        sd_host              => $sd_host,
        sd_password          => $sd_password,
        postgresql_auth_line => $postgresql_auth_line,
        bacula_db_password   => $bacula_db_password,
        tls_enable           => $tls_enable,
        default_schedules    => $default_schedules,
        email                => $email,
        volume_retention     => $volume_retention,
        max_volume_bytes     => $max_volume_bytes,
        max_volumes          => $max_volumes,
    }

    include ::bacula::director::service

    # This class will have to be included, or this node won't be able to export 
    # firewall resources to the Bacula Filedaemons and the Storagedaemon
    include ::bacula::director::export

    if tagged('monit') {
        class { '::bacula::director::monit':
            monitor_email => $monitor_email,
        }
    }

    if tagged('packetfilter') {
        class { '::bacula::director::packetfilter':
            console_host => $console_host,
        }
    }
}
}
