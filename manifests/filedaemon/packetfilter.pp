#
# == Class: bacula::filedaemon::packetfilter
#
# Configure packet filtering rules for Bacula Filedaemon
# 
class bacula::filedaemon::packetfilter {

    # Allow bacula director to contact this filedaemon. This is only done if 
    # Puppet is managing the packet filtering rules.
    Firewall <<| tag == 'bacula-director-to-filedaemon' |>>

}
