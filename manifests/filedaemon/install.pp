#
# == Class: bacula::filedaemon::install
#
# Install Bacula Filedaemon
#
class bacula::filedaemon::install
(
    $package_name,
) inherits bacula::params
{

    package { 'bacula-filedaemon':
        name => "$package_name",
        ensure => installed,
        require => Class['bacula::common'],
    }
}
