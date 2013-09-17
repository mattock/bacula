#
# == Class: bacula::filedaemon::install
#
# Install Bacula Filedaemon
#
class bacula::filedaemon::install {

    include bacula::params

    package { 'bacula-filedaemon':
        name => "${::bacula::params::bacula_filedaemon_package}",
        ensure => installed,
        require => Class['bacula::common'],
    }
}
