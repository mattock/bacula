#
# == Class bacula::storagedaemon::monit
#
# Setup monit rules for Bacula Storagedaemon
#
class bacula::storagedaemon::monit(
    $monitor_email
)
{

  @monit::fragment { 'bacula-bacula-sd.monit':
    modulename => 'bacula',
    basename   => 'bacula-sd',
    tag        => 'default',
  }
}
