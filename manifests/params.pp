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
            $bacula_group = 'bacula'
            $pid_directory = '/var/run'
            $log_directory = '/var/log/bacula'
            $working_directory = '/var/spool/bacula'
            $conf_dir = '/etc/bacula'
            $ssl_dir = "${conf_dir}/ssl"
            $query_file = '/etc/bacula/query.sql'
            $script_dir = '/usr/libexec/bacula'
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
            $bacula_group = 'bacula'
            $pid_directory = '/var/run/bacula'
            $log_directory = '/var/lib/bacula/log'
            $working_directory = '/var/lib/bacula'
            $conf_dir = '/etc/bacula'
            $ssl_dir = "${conf_dir}/ssl"
            $query_file = '/etc/bacula/scripts/query.sql'
            $script_dir = '/usr/share/bacula-director'
        }
        'FreeBSD': {
            $bacula_filedaemon_package = 'bacula-client'
            $bacula_filedaemon_config = '/usr/local/etc/bacula/bacula-fd.conf'
            $bacula_filedaemon_service = 'bacula-fd'
            $bacula_group = 'bacula'
            $pid_directory = '/var/run'
            $working_directory = '/var/db/bacula'
            $conf_dir = '/usr/local/etc/bacula'
            $ssl_dir = "${conf_dir}/ssl"
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    $bacula_director_pidfile = "${pid_directory}/bacula-dir.9101.pid"
    $bacula_storagedaemon_pidfile = "${pid_directory}/bacula-sd.9103.pid"
    $bacula_filedaemon_pidfile = "${pid_directory}/bacula-fd.9102.pid"

    if str2bool($::has_systemd) {
        $bacula_director_service_start = "${::os::params::systemctl} start ${bacula_director_service}"
        $bacula_director_service_stop = "${::os::params::systemctl} stop ${bacula_director_service}"
        $bacula_storagedaemon_service_start = "${::os::params::systemctl} start ${bacula_storagedaemon_service}"
        $bacula_storagedaemon_service_stop = "${::os::params::systemctl} stop ${bacula_storagedaemon_service}"
        $bacula_filedaemon_service_start = "${::os::params::systemctl} start ${bacula_filedaemon_service}"
        $bacula_filedaemon_service_stop = "${::os::params::systemctl} stop ${bacula_filedaemon_service}"
    } else {
        $bacula_director_service_start = "${::os::params::service_cmd} ${bacula_director_service} start"
        $bacula_director_service_stop = "${::os::params::service_cmd} ${bacula_director_service} stop"
        $bacula_storagedaemon_service_start = "${::os::params::service_cmd} ${bacula_storagedaemon_service} start"
        $bacula_storagedaemon_service_stop = "${::os::params::service_cmd} ${bacula_storagedaemon_service} stop"
        $bacula_filedaemon_service_start = "${::os::params::service_cmd} ${bacula_filedaemon_service} start"
        $bacula_filedaemon_service_stop = "${::os::params::service_cmd} ${bacula_filedaemon_service} stop"
    }
}
