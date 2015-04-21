#
# == Class: bacula::console::config
#
# Configure Bacula console
#
class bacula::console::config
(
    $director_name,
    $director_address_ipv4,
    $director_password,
    $tls_enable
)
{
    file { 'bacula-bconsole.conf':
        name    => '/etc/bacula/bconsole.conf',
        content => template('bacula/bconsole.conf.erb'),
        mode    => '0640',
        owner   => root,
        group   => root,
        require => Class['bacula::console::install'],
    }
}
