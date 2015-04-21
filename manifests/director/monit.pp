#
# == Class bacula::director::monit
#
# Setup monit rules for Bacula Director
#
class bacula::director::monit(
    $monitor_email
)
{
  monit::fragment { 'bacula-bacula-dir.monit':
        modulename => 'bacula',
        basename   => 'bacula-dir',
  }
}
