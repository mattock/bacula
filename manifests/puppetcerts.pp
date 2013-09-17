#
# == Class: bacula::puppetcerts
#
# Copy puppet certificates to a place where Bacula daemons can find them. Note 
# that this class depends on puppetagent::params class for locating Puppet's SSL 
# certificates.
#
class bacula::puppetcerts {

    include bacula::params
    include puppetagent::params

    file { 'bacula-ssl-dir':
        ensure => directory,
        name => "${::bacula::params::ssl_dir}",
        owner => root,
        group => bacula,
        mode => 750,
        require => Class['bacula::common'],
    }

    exec { 'copy-puppet-cert-to-bacula.crt':
        command => "cp -f ${::puppetagent::params::ssl_dir}/certs/$fqdn.pem ${::bacula::params::ssl_dir}/bacula.crt",
        unless => "cmp ${::puppetagent::params::ssl_dir}/certs/$fqdn.pem ${::bacula::params::ssl_dir}/bacula.crt",
        path => ['/bin', '/usr/bin/' ],
        require => File['bacula-ssl-dir'],
    }

    exec { 'copy-puppet-key-to-bacula.key':
        command => "cp -f ${::puppetagent::params::ssl_dir}/private_keys/$fqdn.pem ${::bacula::params::ssl_dir}/bacula.key",
        unless => "cmp ${::puppetagent::params::ssl_dir}/private_keys/$fqdn.pem ${::bacula::params::ssl_dir}/bacula.key",
        path => ['/bin', '/usr/bin/' ],
        require => File['bacula-ssl-dir'],
    }

    exec { 'copy-puppet-ca-cert-to-bacula-ca.crt':
        command => "cp -f ${::puppetagent::params::ssl_dir}/certs/ca.pem ${::bacula::params::ssl_dir}/bacula-ca.crt",
        unless => "cmp ${::puppetagent::params::ssl_dir}/certs/ca.pem ${::bacula::params::ssl_dir}/bacula-ca.crt",
        path => ['/bin', '/usr/bin/' ],
        require => File['bacula-ssl-dir'],
    }

    file { 'bacula.crt':
        name => "${::bacula::params::ssl_dir}/bacula.crt",
        owner => root,
        group => bacula,
        mode => 644,
        require => Exec['copy-puppet-cert-to-bacula.crt'],
    }

    file { 'bacula.key':
        name => "${::bacula::params::ssl_dir}/bacula.key",
        owner => root,
        group => bacula,
        mode => 640,
        require => Exec['copy-puppet-key-to-bacula.key'],
    }

    file { 'bacula-ca.crt':
        name => "$ssl_dir/bacula-ca.crt",
        owner => root,
        group => bacula,
        mode => 644,
        require => Exec['copy-puppet-ca-cert-to-bacula-ca.crt'],
    }
}
