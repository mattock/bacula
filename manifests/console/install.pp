#
# == Class: bacula::console::install
#
# Install Bacula Console
#
class bacula::console::install {
    package { 'bacula-console':
        name => 'bacula-console',
        ensure => installed,
        require => Class['bacula::common'],
    }
}
