#
# == Class: bacula::common::install
#
# Install common components for all bacula daemons
#
class bacula::common::install {

    package { 'bacula-bacula-common':
        name => 'bacula-common',
        ensure => installed,
    }
}
