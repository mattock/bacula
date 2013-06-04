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
    $backup_files
)
{

    include bacula::params

    file { 'bacula-bacula-fd.conf':
        name => '/etc/bacula/bacula-fd.conf',
        content => template('bacula/bacula-fd.conf.erb'),
        mode => 640,
        owner => root,
        group => root,
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

    file { 'bacula-bacula-backup.list':
        name => '/etc/bacula-backup.list',
        content => template('bacula/bacula-backup.list.erb'),
        owner => root,
        group => bacula,
        mode => 640,
        require => Class['bacula::filedaemon::install'],
    }
}
