#
# == Class: bacula::director::packetfilter
#
# Setup packet filtering rules for Bacula Director
#
class bacula::director::packetfilter($console_host)
{

    # Get this node's IP based on DNS query done on the puppetmaster. The 
    # ipaddress fact is worthless on nodes with several active interfaces. 
    # Google "puppet facter ipaddress" for details.
    $ipv4_address = generate('/usr/local/bin/getip.sh', '-4', "$fqdn")

    # IPv4 rules
    @@firewall { "012 ipv4 accept bacula filedaemon port from $ipv4_address":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 9102,
        source => "$ipv4_address",
        action => 'accept',       
        tag => 'bacula-director-to-filedaemon',
    }

    @@firewall { "013 ipv4 accept bacula storagedaemon port from $ipv4_address":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 9103,
        source => "$ipv4_address",
        action => 'accept',       
        tag => 'bacula-director-to-storagedaemon',
    }

    # Allow contacting the Director from $console_host
    firewall { "013 ipv4 accept bacula director port from $console_host":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 9101,
        source => "$console_host",
        action => 'accept',
    }

    # IPv6 rules

    # FIXME: Facter does not return IPv6 addresses. As we don't (yet) use IPv6 
    # as transport, allowing traffic only from ::1 is not critical, but should 
    # definitely be fixed.
    #@@firewall { "012 ipv6 accept bacula filedaemon port from localhost":
    #    provider => "ip6tables",
    #    chain => "INPUT",
    #    proto => "tcp",
    #    port => 9102,
    #    source => "::1",
    #    action => "accept",
    #    tag => "bacula-director-to-filedaemon",
    #}

    #@@firewall { "013 ipv6 accept bacula storagedaemon port from localhost":
    #    provider => "ip6tables",
    #    chain => "INPUT",
    #    proto => "tcp",
    #    port => 9103,
    #    source => "::1",
    #    action => "accept",
    #    tag => "bacula-director-to-storagedaemon",
    #}
}
