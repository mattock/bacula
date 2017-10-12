#
# == Class: bacula::filedaemon::install
#
# Install Bacula Filedaemon
#
class bacula::filedaemon::install
(
    Enum['present','absent'] $status,
    String $package_name

) inherits bacula::params
{

    package { 'bacula-filedaemon':
        ensure  => $status,
        name    => $package_name,
        require => Class['bacula::common'],
    }
}
