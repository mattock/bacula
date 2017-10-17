#
# == Class: bacula::storagedaemon::config
#
# Configure Bacula Storagedaemon
#
class bacula::storagedaemon::config
(
    $pwd_for_director,
    $pwd_for_monitor,
    $bind_address,
    $backup_directory,
    $tls_enable

) inherits bacula::params
{

    file { 'bacula-backup-directory':
        ensure => directory,
        name   => $backup_directory,
        owner  => $::bacula::params::bacula_storagedaemon_user,
        group  => $::bacula::params::bacula_storagedaemon_group,
        mode   => '0755',
    }

    file { 'bacula-bacula-sd.conf':
        ensure  => present,
        name    => '/etc/bacula/bacula-sd.conf',
        content => template('bacula/bacula-sd.conf.erb'),
        mode    => '0640',
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        notify  => Class['bacula::storagedaemon::service'],
        require => File['bacula-backup-directory'],
    }

}
