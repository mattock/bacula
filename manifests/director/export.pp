#
# == Class: bacula::director::export
#
# Export packet filtering rules for Bacula Filedaemons and Storagedaemon
#
# NOTE: this is not called bacula::director::packetfilter::export, because that 
# makes puppet think the node has the 'packetfilter' tag, which in turn makes 
# puppet manage the firewall rules on _this_ node, which we don't always want.
#
class bacula::director::export
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
}
