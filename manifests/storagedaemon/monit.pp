#
# == Class bacula::storagedaemon::monit
#
# Setup monit rules for Bacula Storagedaemon
#
class bacula::storagedaemon::monit {

	monit::fragment { 'bacula-bacula-sd.monit':
		modulename => 'bacula',
        basename => 'bacula-sd',
	}
}
