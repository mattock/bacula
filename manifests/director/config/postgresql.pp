#
# == Class: bacula::director::config::postgresql
#
# Configure the Bacula database on postgresql server. Currently only supports 
# Debian (and possibly Ubuntu).
#
class bacula::director::config::postgresql
(
    $postgresql_auth_line,
    $bacula_db_password
)
{

    # Prepare postgresql for Bacula's own database schema scripts
    postgresql::loadsql { 'bacula-bacula-director.sql':
        modulename => 'bacula',
        basename => 'bacula-director',
    }

    exec { 'bacula-make_postgresql_tables':
        environment => [ 'db_name=bacula' ],
        command => '/usr/share/bacula-director/make_postgresql_tables',
        cwd => '/tmp',
        path => [ '/usr/bin' ],
        user => 'postgres',
        refreshonly => true,
        require => Postgresql::Loadsql['bacula-bacula-director.sql'],
    }

    # FIXME: apparently this does not get run during initial install. Add tests
    # to determine if the database privileges are in place already.
    exec { 'bacula-grant_postgresql_privileges':
        environment => [ 'db_name=bacula', 'db_user=baculauser' ],
        command => '/usr/share/bacula-director/grant_postgresql_privileges',
        cwd => '/tmp',
        path => [ '/usr/bin' ],
        user => 'postgres',
        refreshonly => true,
        require => Exec['bacula-make_postgresql_tables'],
    }

    # Add an authentication line for baculauser to postgresql pg_hba.conf
    Postgresql::Config::Auth::File <| title == 'default-pg_hba.conf' |> {
        postgresql_auth_lines +> "$postgresql_auth_line",
    }

}
