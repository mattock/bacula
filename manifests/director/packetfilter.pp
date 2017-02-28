#
# == Class: bacula::director::packetfilter
#
# Setup packet filtering rules for Bacula Director
#
class bacula::director::packetfilter($console_host)
{
    # Allow contacting the Director from $console_host
    @firewall { "013 ipv4 accept bacula director port from ${console_host}":
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => 9101,
        source   => $console_host,
        action   => 'accept',
        tag      => 'default',
    }
}
