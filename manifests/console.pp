#
# == Class: bacula::console
#
# Setup Bacula console. Currently only install the package.
#
# == Parameters
#
# [*director_name*]
#   Name of the Director to contact
# [*director_address_ipv4*]
#   IPv4 address of the Director to contact
# [*director_password*]
#   Director's console password
# [*tls_enable*]
#   Enable TLS. Defaults to 'no'.
# [*use_puppet_certs*]
#   Use puppet certs for TLS. Defaults to 'yes'.
#
# == Examples
#
#   include bacula::console
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class bacula::console
(
    $director_name,
    $director_address_ipv4,
    $director_password,
    $tls_enable = 'no',
    $use_puppet_certs = 'yes'
)
{

if hiera('manage_bacula_console', true) != false {

    if ( $use_puppet_certs == 'yes' ) and ( $tls_enable == 'yes' ) {
        include ::bacula::puppetcerts
    }

    include ::bacula::common
    include ::bacula::console::install

    class { '::bacula::console::config':
        director_name         => $director_name,
        director_address_ipv4 => $director_address_ipv4,
        director_password     => $director_password,
        tls_enable            => $tls_enable,
    }
}
}
