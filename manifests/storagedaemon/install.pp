#
# == Class: bacula::storagedaemon::install
#
# Install Bacula Storagedaemon. Currently installs a package that pulls in 
# postgresql support.
#
class bacula::storagedaemon::install {

    include ::bacula::params

    package { 'bacula-storagedaemon':
        ensure  => installed,
        name    => $::bacula::params::bacula_storagedaemon_package,
        require => Class['bacula::common'],
    }
}
