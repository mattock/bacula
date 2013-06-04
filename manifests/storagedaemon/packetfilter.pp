#
# == Class: bacula::storagedaemon::packetfilter
#
# Configure packet filtering rules for Bacula Storagedaemon. This basically just 
# pulls in all the exported Firewall resources from the Filedaemons and the 
# Director and realizes them on the Storagedaemon node.
#
class bacula::storagedaemon::packetfilter {

    # See bacula::filedaemon::packetfilter for discussion on pros and cons of 
    # this exported resources approach

    Firewall <<| tag == 'bacula-director-to-storagedaemon' |>>
    Firewall <<| tag == 'bacula-filedaemon-to-storagedaemon' |>>

}
