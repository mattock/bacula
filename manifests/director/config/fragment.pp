#
# == Define: bacula::director::config::fragment
#
# Define used to export Bacula Director configuration file fragments from 
# Filedaemons. Used to configure what directories to backup in each filedaemon 
# node, instead of in a static fashion in the Director configuration.
#
define bacula::director::config::fragment
(
    $fd_password
)
{

    include ::bacula::params

    @@file { "bacula-dir.conf.d-fragment-${::fqdn}":
        name    => "/etc/bacula/bacula-dir.conf.d/${::fqdn}.conf",
        content => template('bacula/bacula-dir.conf.d-fragment.erb'),
        mode    => '0640',
        owner   => $::os::params::admingroup,
        group   => $::bacula::params::bacula_group,
        tag     => 'bacula-dir.conf.d-fragment',
    }
}
