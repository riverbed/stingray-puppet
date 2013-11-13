# == Define: ssl_certificate
#
# Import an SSL Certificate to the Stingray Traffic Manager catalog.
#
# === Parameters
#
# [*name*]
# The name to give the SSL Certificate being imported to the catalog.
#
# [*certificate_file*]
# Path to the PEM encoded certificate file
#
# [*private_key_file*]
# Path to the PEM encoded private key file. The Private key must not
# be encrypted. You can use openssl to unencrypt the key:
#
#   openssl rsa -in key.private
#
# === Examples
#
#  stingray::ssl_certificate { 'My SSL Certificate':
#      certificate_file => 'puppet:///modules/stingray/cert.public',
#      private_key_file => 'puppet:///modules/stingray/cert.private'
#  }
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
#
# === Copyright
#
# Copyright 2013 Riverbed Technology
#
define stingray::ssl_certificate(
    $certificate_file = '',
    $private_key_file = ''

) {
    include stingray

    $path = $stingray::install_dir

    info ("Configuring SSL certificate ${name}")
    file { "${path}/zxtm/conf/ssl/server_keys/${name}.public":
        ensure => 'present',
        source => $certificate_file,
        notify => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/ssl/server_keys/${name}.private":
        ensure => 'present',
        source => $private_key_file,
        notify => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/ssl/server_keys_config":
        ensure  => 'present',
        alias   => 'server_keys_config',
        require => [ Exec['new_stingray_cluster'], ],
        notify  => Exec['replicate_config']
    }

    file_line { 'public key':
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!public  ${path}/zxtm/conf/ssl/server_keys/${name}.public",
        require => File['server_keys_config'],
        notify  => Exec['replicate_config']
    }

    file_line { 'private key':
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!private  ${path}/zxtm/conf/ssl/server_keys/${name}.private",
        require => File['server_keys_config'],
        notify  => Exec['replicate_config']
    }

    file_line { 'managed':
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!managed  yes",
        require => File['server_keys_config'],
        notify  => Exec['replicate_config']
    }
}
