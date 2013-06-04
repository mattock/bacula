#
# == Class: bacula::puppetcerts
#
# Copy puppet certificates to a place where Bacula daemons can find them
#
class bacula::puppetcerts(
    $puppet_ssl_dir = '/var/lib/puppet/ssl',
    $bacula_ssl_dir = '/etc/bacula/ssl'
)
{
    file { 'bacula-ssl-dir':
        ensure => directory,
        name => "$bacula_ssl_dir",
        owner => root,
        group => bacula,
        mode => 750,
        require => Class['bacula::common'],
    }

    exec { 'copy-puppet-cert-to-bacula.crt':
        command => "cp -f $puppet_ssl_dir/certs/$fqdn.pem $bacula_ssl_dir/bacula.crt",
        unless => "cmp $puppet_ssl_dir/certs/$fqdn.pem $bacula_ssl_dir/bacula.crt",
        path => ['/bin', '/usr/bin/' ],
        require => File['bacula-ssl-dir'],
    }

    exec { 'copy-puppet-key-to-bacula.key':
        command => "cp -f $puppet_ssl_dir/private_keys/$fqdn.pem $bacula_ssl_dir/bacula.key",
        unless => "cmp $puppet_ssl_dir/private_keys/$fqdn.pem $bacula_ssl_dir/bacula.key",
        path => ['/bin', '/usr/bin/' ],
        require => File['bacula-ssl-dir'],
    }

    exec { 'copy-puppet-ca-cert-to-bacula-ca.crt':
        command => "cp -f $puppet_ssl_dir/certs/ca.pem $bacula_ssl_dir/bacula-ca.crt",
        unless => "cmp $puppet_ssl_dir/certs/ca.pem $bacula_ssl_dir/bacula-ca.crt",
        path => ['/bin', '/usr/bin/' ],
        require => File['bacula-ssl-dir'],
    }

    file { 'bacula.crt':
        name => "$bacula_ssl_dir/bacula.crt",
        owner => root,
        group => bacula,
        mode => 644,
        require => Exec['copy-puppet-cert-to-bacula.crt'],
    }

    file { 'bacula.key':
        name => "$bacula_ssl_dir/bacula.key",
        owner => root,
        group => bacula,
        mode => 640,
        require => Exec['copy-puppet-key-to-bacula.key'],
    }

    file { 'bacula-ca.crt':
        name => "$bacula_ssl_dir/bacula-ca.crt",
        owner => root,
        group => bacula,
        mode => 644,
        require => Exec['copy-puppet-ca-cert-to-bacula-ca.crt'],
    }
}
