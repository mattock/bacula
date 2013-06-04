#
# == Class: bacula::director::install
#
# Install Bacula Director
#
class bacula::director::install {

    include bacula::params

    package { 'bacula-director':
        name => $::bacula::params::bacula_director_package,
        ensure => installed,
        require => Class['bacula::common'],
    }
}
