#
# == Class: bacula::storagedaemon::packetfilter
#
# Configure packet filtering rules for Bacula Storagedaemon. This basically just 
# pulls in all the exported Firewall resources from the Filedaemons and the 
# Director and realizes them on the Storagedaemon node.
#
class bacula::storagedaemon::packetfilter($allow_additional_ipv4_addresses) {

    # Realize firewall rules exported by the Director and Filedaemons. See 
    # bacula::filedaemon::packetfilter for discussion on pros and cons of this 
    # exported resources approach
    Firewall <<| tag == 'bacula-director-to-storagedaemon' |>>
    Firewall <<| tag == 'bacula-filedaemon-to-storagedaemon' |>>

    # Allow additional IPv4 addresses. See bacula::storagedaemon class 
    # documentation for the rationale.
    if $allow_additional_ipv4_addresses == 'none' {
        # Do nothing
    } else {
        bacula::storagedaemon::packetfilter::allow_ip { $allow_additional_ipv4_addresses: }
    }
}
