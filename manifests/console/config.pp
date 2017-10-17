#
# == Class: bacula::console::config
#
# Configure Bacula console
#
class bacula::console::config
(
    $director_address_ipv4,
    $director_password,
    $tls_enable

) inherits bacula::params
{
    file { 'bacula-bconsole.conf':
        name    => '/etc/bacula/bconsole.conf',
        content => template('bacula/bconsole.conf.erb'),
        mode    => '0640',
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        require => Class['bacula::console::install'],
    }
}
