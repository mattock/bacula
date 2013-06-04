#
# == Define: bacula::director::config::fragment
#
# Define used to export Bacula Director configuration file fragments from 
# Filedaemons. Used to configure what directories to backup in each filedaemon 
# node, instead of in a static fashion in the Director configuration.
#
define bacula::director::config::fragment($fd_password)
{
    @@file { "bacula-dir.conf.d-fragment-${fqdn}":
        name => "/etc/bacula/bacula-dir.conf.d/${fqdn}.conf",
        content => template('bacula/bacula-dir.conf.d-fragment.erb'),
        mode => 640,
        owner => root,
        group => bacula,
        tag => 'bacula-dir.conf.d-fragment',
    }
}
