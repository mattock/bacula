# This manifest is only used by Vagrant

$email = 'root@localhost'

if $::osfamily == 'RedHat' {
    include ::epel
}

class { '::monit':
    email => $email,
}

# Ensure that Puppet certificate managements works - these code paths are not
# exercised when using "puppet apply".
$ssl_dir = '/etc/puppetlabs/puppet/ssl'
file { ["${ssl_dir}/certs/ca.pem", "${ssl_dir}/certs/${::fqdn}.pem", "${ssl_dir}/private_keys/${::fqdn}.pem" ]:
    ensure => 'present',
}
include ::bacula::common
include ::bacula::puppetcerts

# Ensure that Bacula Filedaemon works
class { '::bacula::filedaemon':
    status                => 'present',
    manage_packetfilter   => true,
    manage_monit          => true,
    use_puppet_certs      => false,
    tls_enable            => false,
    director_address_ipv4 => '192.168.138.200',
    pwd_for_director      => 'director',
    pwd_for_monitor       => 'monitor',
    backup_files          => [ '/tmp/modules' ],
    messages              => 'AllButInformational',
    monitor_email         => $email,
}
