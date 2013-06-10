#
# == Class: bacula::filedaemon::export
#
# Export firewall rules for the Bacula Storagedaemon.
#
# NOTE: this is not called bacula::filedaemon::packetfilter::export, because 
# that makes puppet think the node has the 'packetfilter' tag, which in turn 
# makes puppet manage the firewall rules on _this_ node, which we don't always 
# want.
#
class bacula::filedaemon::export {

    # Get this node's IP based on DNS query done on the puppetmaster. Look at 
    # bacula::director::packetfilter for details on the rationale.
    $ipv4_address = generate("/usr/local/bin/getip.sh", "-4", "$fqdn")

    # Export IPv4 rules to the Storagedaemon node
    @@firewall { "012 ipv4 accept bacula storagedaemon port from $ipv4_address":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 9103,
        source => "$ipv4_address",
        action => 'accept',
        tag => 'bacula-filedaemon-to-storagedaemon',
    }
}
