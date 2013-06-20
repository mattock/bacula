#
# == Class: bacula::director::config
#
# Configure bacula director
#
class bacula::director::config
    (
    $bind_address,
    $pwd_for_console,
    $pwd_for_monitor,
    $sd_host,
    $sd_password,
    $postgresql_auth_line,
    $bacula_db_password,
    $tls_enable,
    $default_schedules
    )
    {

    class { 'bacula::director::config::postgresql':
        postgresql_auth_line => $postgresql_auth_line,
        bacula_db_password => $bacula_db_password,
    }

    file { 'bacula-bacula-dir.conf':
        name => '/etc/bacula/bacula-dir.conf',
        ensure => present,
        content => template('bacula/bacula-dir.conf.erb'),
        mode => 640,
        owner => root,
        group => bacula,
        notify => Class['bacula::director::service'],
        require => Class['bacula::director::install'],
    }

    file { 'bacula-bacula-dir.conf.d':
        name => '/etc/bacula/bacula-dir.conf.d',
        ensure => directory,
        mode => 750,
        owner => root,
        group => bacula,
        require => Class['bacula::director::install'],
    }

    # Import exported configuration fragments from clients
    File <<| tag == 'bacula-dir.conf.d-fragment' |>>
}
