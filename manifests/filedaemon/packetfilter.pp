#
# == Class: bacula::filedaemon::packetfilter
#
# Configure packet filtering rules for Bacula Filedaemon
# 
class bacula::filedaemon::packetfilter {

    # Allow bacula director to contact this filedaemon
    Firewall <<| tag == "bacula-director-to-filedaemon" |>>

    # Get this node's IP based on DNS query done on the puppetmaster. Look at 
    # bacula::director::packetfilter for details on the rationale.
    $ipv4_address = generate("/usr/local/bin/getip.sh", "-4", "$fqdn")

    # IPv4 rules
    @@firewall { "012 ipv4 accept bacula storagedaemon port from $ipv4_address":
        provider => "iptables",
        chain => "INPUT",
        proto => "tcp",
        port => 9103,
        source => "$ipv4_address",
        action => "accept",
        tag => "bacula-filedaemon-to-storagedaemon",
    }

    # IPv6 rules

    # FIXME: Facter does not return IPv6 addresses. As we don't (yet) use IPv6 
    # as transport, allowing traffic only from ::1 is not critical, but should 
    # definitely be fixed.
    #@@firewall { "014 ipv6 accept bacula storagedaemon port from localhost":
    #    provider => "ip6tables",
    #    chain => "INPUT",
    #    proto => "tcp",
    #    port => 9103,
    #    source => "::1",
    #    action => "accept",
    #    tag => "bacula-filedaemon-to-storagedaemon",
    #}



}
