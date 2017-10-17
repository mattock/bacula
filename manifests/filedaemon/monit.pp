#
# == Class bacula::filedaemon::monit
#
# Setup monit rules for Bacula Filedaemon
#
class bacula::filedaemon::monit
(
    Enum['present','absent'] $status,
    String $monitor_email
)
{
  @monit::fragment { 'bacula-bacula-fd.monit':
        ensure     => $status,
        modulename => 'bacula',
        basename   => 'bacula-fd',
        tag        => 'default',
  }
}
