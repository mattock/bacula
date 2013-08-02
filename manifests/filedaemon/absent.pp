#
# == Class: bacula::absent
#
# Various obsolete configurations that are removed automatically to prevent 
# problems.
#
class bacula::filedaemon::absent {

    # Bacula's @include reads a file from _Directors_ filesystem, not from 
    # FileDaemons' filesystem. This means that the $backup_files parameter of 
    # bacula::filedaemon that populates this file is basically useless, and we 
    # need to get rid of it.
    file { 'bacula-bacula-backup.list':
        name => '/etc/bacula-backup.list',
        ensure => absent,
    }
}
