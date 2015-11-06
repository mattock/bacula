#
# == Class: bacula::common
#
# Setup common components for all bacula daemons
#
class bacula::common {

    # We need to create the bacula group _before_ installing Bacula, or the 
    # ::bacula::puppetcerts class will fail on first Puppet run.
    group { 'bacula':
        ensure => present,
    }

    class { '::bacula::common::install': }

}

