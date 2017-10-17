#
# == Class: bacula::director::service
#
# Enable Bacula director service at boot
#
class bacula::director::service {

    include ::bacula::params

    service { 'bacula-director':
        name    => $::bacula::params::bacula_director_service,
        enable  => true,
        require => Class['bacula::director::config::postgresql'],
    }
}
