#
# == Class: bacula::director::config
#
# Configure bacula director
#
class bacula::director::config
(
    $manage_db,
    $bind_address,
    $pwd_for_console,
    $pwd_for_monitor,
    $sd_host,
    $sd_password,
    $postgresql_auth_line,
    $bacula_db_password,
    $tls_enable,
    $default_schedules,
    $file_retention,
    $job_retention,
    $volume_retention,
    $max_volume_bytes,
    $max_volumes,
    $email,
    $email_from
)
{


    if $manage_db {
        class { '::postgresql':
            monitor_email => $email,
        }

        class { '::bacula::director::config::postgresql':
            postgresql_auth_line => $postgresql_auth_line,
            bacula_db_password   => $bacula_db_password,
        }
    }

    $l_email_from = $email_from ? {
        undef   => "bacula@${::fqdn}",
        default => $email_from,
    }

    # Main configuration file
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

    # Configuration fragment directory; mainly for exported configuration 
    # fragments coming from Filedaemon nodes
    file { 'bacula-bacula-dir.conf.d':
        ensure  => directory,
        name    => '/etc/bacula/bacula-dir.conf.d',
        mode    => '0750',
        owner   => root,
        group   => bacula,
        require => Class['bacula::director::install'],
    }

    # Backup catalog. Implemented as a separate fragment so that the Bacula
    # Director does not fail trying to import files from an empty fragment
    # directory.
    file { "bacula-dir.conf.d-fragment-catalog":
        ensure  => 'present',
        name    => "/etc/bacula/bacula-dir.conf.d/catalog.conf",
        content => template('bacula/bacula-dir-catalog.conf.erb'),
        mode    => '0640',
        owner   => root,
        group   => bacula,
        notify  => Class['bacula::director::service'],
        require => File['bacula-bacula-dir.conf.d'],
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
