# This manifest is only used by Vagrant

class { '::bacula::director':
    tls_enable           => 'no',
    use_puppet_certs     => 'no',
    console_host         => 'localhost',
    pwd_for_console      => 'console',
    pwd_for_monitor      => 'monitor',
    sd_host              => 'backup.domain.com',
    sd_password          => 'sd',
    postgresql_auth_line => 'local bacula baculauser  password',
    bacula_db_password   => 'db',
    bind_address         => '0.0.0.0',
    file_retention       => '30 days',
    job_retention        => '90 days',
    volume_retention     => '180 days',
    max_volume_bytes     => '100M',
    max_volumes          => '5',
    email                => 'backup@domain.com',
    monitor_email        => 'monitor@domain.com',
}
