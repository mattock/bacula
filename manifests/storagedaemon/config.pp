#
# == Class: bacula::storagedaemon::config
#
# Configure Bacula Storagedaemon
#
class bacula::storagedaemon::config
(
    $director_name,
    $monitor_name,
    $pwd_for_director,
    $pwd_for_monitor,
    $bind_address,
    $backup_directory,
    $tls_enable
)
{

    include bacula::params

    file { 'bacula-backup-directory':
        name => $backup_directory,
        ensure => directory,
        owner => "${::bacula::params::bacula_storagedaemon_user}",
        group => "${::bacula::params::bacula_storagedaemon_group}",
        mode => 755,
    }

    file { 'bacula-bacula-sd.conf':
        name => '/etc/bacula/bacula-sd.conf',
        content => template('bacula/bacula-sd.conf.erb'),
        mode => 640,
        owner => root,
        group => root,
        notify => Class['bacula::storagedaemon::service'],
        require => File['bacula-backup-directory'],
    }

}
