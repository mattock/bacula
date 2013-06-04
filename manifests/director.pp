#
# == Class: bacula::director
#
# Setup Bacula Director daemon
#
# == Parameters
#
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
class bacula::director(
    $console_host='127.0.0.1',
    $bind_address='127.0.0.1',
    $pwd_for_console,
    $pwd_for_monitor,
    $sd_host='127.0.0.1',
    $sd_password,
    $postgresql_auth_line,
    $bacula_db_password,
    $tls_enable='no',
    $use_puppet_certs='yes'
    )
    {

    if ( $use_puppet_certs == 'yes' ) and ( $tls_enable == 'yes' ) {
        include bacula::puppetcerts
    }

    include bacula::common
    include bacula::director::install

    class { 'bacula::director::config':
        bind_address => $bind_address,
        pwd_for_console => $pwd_for_console,
        pwd_for_monitor => $pwd_for_monitor,
        sd_host => $sd_host,
        sd_password => $sd_password,
        postgresql_auth_line => $postgresql_auth_line,
        bacula_db_password => $bacula_db_password,
        tls_enable => $tls_enable,
    }

    include bacula::director::service

    if tagged('packetfilter') {
        class { 'bacula::director::packetfilter':
            console_host => $console_host,
        }
    }
}
