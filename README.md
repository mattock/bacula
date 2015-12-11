# Bacula

A puppet module to manage Bacula Directors, Storagedaemons and Filedaemons

# Bugs

The _grant_postgresql_privileges_ exec does not seem to work, which leaves 
bacula-director in a limbo. Running it manually makes everything work just 
fine:

    $ su - postgres
    $ cd /usr/share/bacula-director
    $ db_name=bacula db_user=baculauser grant_postgresql_privileges
