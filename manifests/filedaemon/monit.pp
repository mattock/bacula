#
# == Class bacula::filedaemon::monit
#
# Setup monit rules for Bacula Filedaemon
#
class bacula::filedaemon::monit
(
    $status,
    $monitor_email
)
{
  monit::fragment { 'bacula-bacula-fd.monit':
        ensure     => $status,
        modulename => 'bacula',
        basename   => 'bacula-fd',
  }
}
