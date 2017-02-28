#
# == Class: bacula::storagedaemon::packetfilter
#
# Configure packet filtering rules for Bacula Storagedaemon. This basically
# just pulls in all the exported Firewall resources from the Filedaemons and
# the Director and realizes them on the Storagedaemon node.
#
class bacula::storagedaemon::packetfilter
(
    $filedaemon_addresses_ipv4,
    $director_address_ipv4
)
{
    # Allow the Director to contact this StorageDaemon
    @firewall { "013 ipv4 accept bacula storagedaemon port from ${director_address_ipv4}":
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => 9103,
        source   => $director_address_ipv4,
        action   => 'accept',
        tag      => 'default',
    }

    # Allow Filedaemons to contact this StorageDaemon
    bacula::storagedaemon::packetfilter::allow_ip { $filedaemon_addresses_ipv4: }
}
