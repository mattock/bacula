#
# == Class: bacula::common
#
# Setup common components for all bacula daemons
#
class bacula::common {

    class { 'bacula::common::install': }

}

