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

) inherits bacula::params
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

    File {
        owner   => $::os::params::adminuser,
        group   => $::bacula::params::bacula_group,
        require => Class['::bacula::director::install'],
        notify  => Class['::bacula::director::service'],
    }

    # Simplistic config file that pulls in configuration fragments
    file { 'bacula-bacula-dir.conf':
        ensure  => present,
        name    => '/etc/bacula/bacula-dir.conf',
        content => template('bacula/bacula-dir.conf.erb'),
        mode    => '0640',
    }

    # Configuration fragment directory; mainly for exported configuration 
    # fragments coming from Filedaemon nodes
    file { 'bacula-bacula-dir.conf.d':
        ensure  => directory,
        name    => '/etc/bacula/bacula-dir.conf.d',
        mode    => '0750',
    }

    # Main config file
    file { 'director.conf':
        ensure  => present,
        name    => '/etc/bacula/bacula-dir.conf.d/00director.conf',
        content => template('bacula/director.conf.erb'),
        mode    => '0640',
        require => File['bacula-bacula-dir.conf.d'],
    }

    # Make the delete_catalog_backup script executable
    file { 'bacula-delete_catalog_backup':
        name    => '/etc/bacula/scripts/delete_catalog_backup',
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0755',
        notify  => undef,
    }

    # Import exported configuration fragments from clients
    File <<| tag == 'bacula-dir.conf.d-fragment' |>>
}
