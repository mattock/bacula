#
# == Class: bacula::filedaemon::config
#
# Configure Bacula Filedaemon
#
class bacula::filedaemon::config
(
    Enum['present','absent'] $status,
    Boolean $tls_enable,
    String $director_name,
    String $monitor_name,
    String $pwd_for_director,
    String $pwd_for_monitor,
    String $bind_address,
    Array[String] $backup_files,
    Array[String] $exclude_files,
    Array[String] $schedules,
    Enum['All','AllButInformational'] $messages
)
{

    # If the filedaemon was not given a custom schedule, then use the default 
    # defined in the main Director configuration file. The $custom_schedules 
    # variable is used to avoid having to check for undef values in the ERB 
    # template loop.
    if $schedules {
        $schedule_name = "${::fqdn}-schedule"
    } else {
        $schedule_name = 'default-schedule'
    }

    include ::os::params
    include ::bacula::params

    file { 'bacula-bacula-fd.conf':
        ensure  => $status,
        name    => $::bacula::params::bacula_filedaemon_config,
        content => template('bacula/bacula-fd.conf.erb'),
        mode    => '0640',
        owner   => root,
        group   => $::os::params::admingroup,
        require => Class['bacula::filedaemon::install'],
        notify  => Class['bacula::filedaemon::service'],
    }

    # Export a Director configuration fragment from this node.
    @@file { "bacula-dir.conf.d-fragment-${::fqdn}":
        ensure  => $status,
        name    => "/etc/bacula/bacula-dir.conf.d/${::fqdn}.conf",
        content => template('bacula/bacula-dir.conf.d-fragment.erb'),
        mode    => '0640',
        owner   => root,
        group   => bacula,
        notify  => Class['bacula::director::service'],
        tag     => 'bacula-dir.conf.d-fragment',
    }
}
