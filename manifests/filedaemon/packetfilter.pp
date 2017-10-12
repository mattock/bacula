#
# == Class: bacula::filedaemon::packetfilter
#
# Configure packet filtering rules for Bacula Filedaemon
# 
class bacula::filedaemon::packetfilter
(
    Enum['present','absent'] $status,
    String $director_address_ipv4
)
{

    @firewall { "012 ipv4 accept bacula filedaemon port from ${director_address_ipv4}":
        ensure   => $status,
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => 9102,
        source   => $director_address_ipv4,
        action   => 'accept',
        tag      => 'default',
    }
}
