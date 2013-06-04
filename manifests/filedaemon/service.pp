#
# == Class: bacula::filedaemon::service
#
# Enable Bacula Filedaemon at boot
#
class bacula::filedaemon::service {
    service { 'bacula-filedaemon':
        name => $::bacula::params::bacula_filedaemon::service,
        enable => true,
        require => Class['bacula::filedaemon::config'],
    }
}
