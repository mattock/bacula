# This manifest is only used by Vagrant

class { '::monit':
    email => 'root@localhost',
}

# Ensure that Puppet certificate managements works - these code paths are not
# exercised when using "puppet apply".

$ssl_dir = '/etc/puppetlabs/puppet/ssl'

file { ["${ssl_dir}/certs/${::fqdn}.pem", "${ssl_dir}/private_keys/${::fqdn}.pem" ]:
    ensure => 'present',
}

include ::bacula::common
include ::bacula::puppetcerts
