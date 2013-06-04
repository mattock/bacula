#
# == Class: bacula::filedaemon::service
#
# Enable Bacula Filedaemon at boot
#
class bacula::filedaemon::service {

    include bacula::params

    service { 'bacula-filedaemon':
        name => $::bacula::params::bacula_filedaemon_service,
        enable => true,
        require => Class['bacula::filedaemon::config'],
    }
}
