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

    file { 'bacula-bacula-sd.conf':
        name => '/etc/bacula/bacula-sd.conf',
        content => template('bacula/bacula-sd.conf.erb'),
        mode => 640,
        owner => root,
        group => root,
        notify => Class['bacula::storagedaemon::service'],
    }

}
