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
    $default_schedules,
    $volume_retention,
    $max_volume_bytes,
    $max_volumes,
    $email
)
{

    class { '::bacula::director::config::postgresql':
        postgresql_auth_line => $postgresql_auth_line,
        bacula_db_password   => $bacula_db_password,
    }

    file { 'bacula-bacula-dir.conf':
        ensure  => present,
        name    => '/etc/bacula/bacula-dir.conf',
        content => template('bacula/bacula-dir.conf.erb'),
        mode    => '0640',
        owner   => root,
        group   => bacula,
        notify  => Class['bacula::director::service'],
        require => Class['bacula::director::install'],
    }

    file { 'bacula-bacula-dir.conf.d':
        ensure  => directory,
        name    => '/etc/bacula/bacula-dir.conf.d',
        mode    => '0750',
        owner   => root,
        group   => bacula,
        require => Class['bacula::director::install'],
    }

    # Make the delete_catalog_backup script executable
    file { 'bacula-delete_catalog_backup':
        name    => '/etc/bacula/scripts/delete_catalog_backup',
        mode    => '0755',
        require => Class['bacula::director::install'],
    }

    # Import exported configuration fragments from clients
    File <<| tag == 'bacula-dir.conf.d-fragment' |>>
}
