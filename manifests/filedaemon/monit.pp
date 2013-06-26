#
# == Class bacula::filedaemon::monit
#
# Setup monit rules for Bacula Filedaemon
#
class bacula::filedaemon::monit(
    $monitor_email
)
{

	monit::fragment { 'bacula-bacula-fd.monit':
		modulename => 'bacula',
        basename => 'bacula-fd',
	}
}
