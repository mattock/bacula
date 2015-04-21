#
# == Class: bacula::console::install
#
# Install Bacula Console
#
class bacula::console::install {
    package { 'bacula-console':
        ensure  => installed,
        name    => 'bacula-console',
        require => Class['bacula::common'],
    }
}
