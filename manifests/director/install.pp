#
# == Class: bacula::director::install
#
# Install Bacula Director
#
class bacula::director::install {

    include ::bacula::params

    package { 'bacula-director':
        ensure  => installed,
        name    => $::bacula::params::bacula_director_package,
        require => Class['bacula::common'],
    }
}
