#
# == Class: bacula::storagedaemon::install
#
# Install Bacula Storagedaemon. Currently installs a package that pulls in 
# postgresql support.
#
class bacula::storagedaemon::install {

    package { 'bacula-storagedaemon':
        name => $::bacula::params::bacula_storagedaemon_package,
        ensure => installed,
        require => Class['bacula::common'],
    }
}
