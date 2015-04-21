#
# == Class: bacula::filedaemon::packetfilter
#
# Configure packet filtering rules for Bacula Filedaemon
# 
class bacula::filedaemon::packetfilter
(
    $status,
    $director_address_ipv4
)
{

    # Allow bacula director to contact this filedaemon. This is only done if 
    # Puppet is managing the packet filtering rules.
    #
    # By default we use whatever IP-address the Director exported. If a custom 
    # IP-address has been defined, we use that instead.
    if $director_address_ipv4 == 'auto' {
        Firewall <<| tag == 'bacula-director-to-filedaemon' |>>

    } else {
        firewall { "012 ipv4 accept bacula filedaemon port from \
                    ${director_address_ipv4}":
            ensure   => $status,
            provider => 'iptables',
            chain    => 'INPUT',
            proto    => 'tcp',
            port     => 9102,
            source   => $director_address_ipv4,
            action   => 'accept',
        }
    }
}
