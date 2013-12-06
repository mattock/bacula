#
# == Class: bacula::params
#
# Defines some variables based on the operating system
#
class bacula::params {

    case $::osfamily {
        'RedHat': {
            $bacula_director_package = 'bacula-director-postgresql'
            $bacula_director_service = 'bacula-dir'
            $bacula_filedaemon_package = 'bacula-client'
            $bacula_filedaemon_config = '/etc/bacula/bacula-fd.conf'
            $bacula_filedaemon_service = 'bacula-fd'
            $bacula_storagedaemon_package = 'bacula-storage-postgresql'
            $bacula_storagedaemon_service = 'bacula-sd'
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
            $bacula_filedaemon_package = 'bacula-fd'
            $bacula_filedaemon_config = '/etc/bacula/bacula-fd.conf'
            $bacula_filedaemon_service = 'bacula-fd'
            $pid_directory = '/var/run/bacula'
            $working_directory = '/var/lib/bacula'
            $ssl_dir = '/etc/bacula/ssl'
        }
    }
}
