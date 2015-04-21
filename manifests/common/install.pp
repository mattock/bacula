#
# == Class: bacula::common::install
#
# Install common components for all bacula daemons
#
class bacula::common::install {

    # FreeBSD does not have a separate bacula-common port
    if $::operatingsystem != 'FreeBSD' {
        package { 'bacula-bacula-common':
            ensure => installed,
            name   => 'bacula-common',
        }
    }
}
