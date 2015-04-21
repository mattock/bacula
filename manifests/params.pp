#
# == Class: bacula::params
#
# Defines some variables based on the operating system
#
class bacula::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $bacula_director_package = 'bacula-director-postgresql'
            $bacula_director_service = 'bacula-dir'
            $bacula_filedaemon_package = 'bacula-client'
            $bacula_filedaemon_config = '/etc/bacula/bacula-fd.conf'
            $bacula_filedaemon_service = 'bacula-fd'
            $bacula_storagedaemon_package = 'bacula-storage-postgresql'
            $bacula_storagedaemon_service = 'bacula-sd'
            $bacula_storagedaemon_user = 'bacula'
            $bacula_storagedaemon_group = 'tape'
            $pid_directory = '/var/run'
            $working_directory = '/var/spool/bacula'
            $ssl_dir = '/etc/bacula/ssl'
        }
        'Debian': {
            $bacula_director_package = 'bacula-director-pgsql'
            $bacula_director_service = 'bacula-director'
            $bacula_filedaemon_package = 'bacula-fd'
            $bacula_filedaemon_config = '/etc/bacula/bacula-fd.conf'
            $bacula_filedaemon_service = 'bacula-fd'
            $bacula_storagedaemon_package = 'bacula-sd-pgsql'
            $bacula_storagedaemon_service = 'bacula-sd'
            $bacula_storagedaemon_user = 'bacula'
            $bacula_storagedaemon_group = 'tape'
            $pid_directory = '/var/run/bacula'
            $working_directory = '/var/lib/bacula'
            $ssl_dir = '/etc/bacula/ssl'
        }
        'FreeBSD': {
            $bacula_filedaemon_package = 'bacula-client'
            $bacula_filedaemon_config = '/usr/local/etc/bacula/bacula-fd.conf'
            $bacula_filedaemon_service = 'bacula-fd'
            $pid_directory = '/var/run'
            $working_directory = '/var/db/bacula'
            $ssl_dir = '/usr/local/etc/bacula/ssl'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    if $::has_systemd {
        $bacula_filedaemon_service_start = "${::os::params::systemctl} start ${bacula_filedaemon_service}"
        $bacula_filedaemon_service_stop = "${::os::params::systemctl} stop ${bacula_filedaemon_service}"
    } else {
        $bacula_filedaemon_service_start = "${::os::params::service_cmd} ${bacula_filedaemon_service} start"
        $bacula_filedaemon_service_stop = "${::os::params::service_cmd} ${bacula_filedaemon_service} stop"
    }
}
