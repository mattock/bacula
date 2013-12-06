#
# == Class: bacula::filedaemon::config
#
# Configure Bacula Filedaemon
#
class bacula::filedaemon::config
(
    $director_name,
    $monitor_name,
    $pwd_for_director,
    $pwd_for_monitor,
    $bind_address,
    $tls_enable,
    $backup_files,
    $schedules,
    $messages
)
{

    # If the filedaemon was not given a custom schedule, then use the default 
    # defined in the main Director configuration file
    if $schedules == '' {
        $schedule_name = 'default-schedule'
    } else {
        $schedule_name = "${::fqdn}-schedule"
    }

    include os::params
    include bacula::params

    file { 'bacula-bacula-fd.conf':
        name => "${::bacula::params::bacula_filedaemon_config}",
        content => template('bacula/bacula-fd.conf.erb'),
        mode => 640,
        owner => root,
        group => "${::os::params::admingroup}",
        require => Class['bacula::filedaemon::install'],
        notify => Class['bacula::filedaemon::service'],
    }

    # Export a Director configuration fragment from this node.
    @@file { "bacula-dir.conf.d-fragment-${fqdn}":
        name => "/etc/bacula/bacula-dir.conf.d/${fqdn}.conf",
        content => template('bacula/bacula-dir.conf.d-fragment.erb'),
        mode => 640,
        owner => root,
        group => bacula,
        notify => Class['bacula::director::service'],
        tag => 'bacula-dir.conf.d-fragment',
    }

}
