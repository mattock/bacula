#
# == Class: bacula::filedaemon::service
#
# Enable Bacula Filedaemon at boot
#
class bacula::filedaemon::service
(
    Enum['present','absent'] $ensure

) inherits bacula::params
{

    # Service should be disabled if Bacula Filedaemon should be absent
    $enable = $ensure ? {
        'present' => true,
        'absent' => false
    }

    service { 'bacula-filedaemon':
        name    => $::bacula::params::bacula_filedaemon_service,
        enable  => $enable,
        require => Class['bacula::filedaemon::config'],
    }
}
