#
# == Define: bacula::storagedaemon::packetfilter::allow_ip
#
# Allow connections to the Storagedaemon from the specified IPv4 
# address/network.
#
define bacula::storagedaemon::packetfilter::allow_ip() {

    firewall { "012 ipv4 accept bacula filedaemon port from ${title}":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 9102,
        source => "${title}",
        action => 'accept',
    }
}
