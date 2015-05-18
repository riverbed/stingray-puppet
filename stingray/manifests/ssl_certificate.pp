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
    $private_key_file = '',
    $request_file = '',
    $createdvia = 'software',
    $protection = 'software',
    $note = 'Added via puppet'
) {
    include stingray

    $path = $stingray::install_dir

    info ("Configuring SSL certificate ${name}")
    # Upload ssl key files
    file { "${path}/zxtm/conf/ssl/server_keys/${name}.public":
        ensure => 'present',
        source => $certificate_file,
        alias  => 'stingray_public_key',
        notify => Exec['replicate_config'],
        require => Exec['new_stingray_cluster']
    }
    file { "${path}/zxtm/conf/ssl/server_keys/${name}.private":
        ensure => 'present',
        source => $private_key_file,
        notify => Exec['replicate_config'],
        alias  => 'stingray_private_key',
        require => Exec['new_stingray_cluster']
    }
    file { "${path}/zxtm/conf/ssl/server_keys/${name}.request":
        ensure => 'present',
        source => $request_file,
        notify => Exec['replicate_config'],
        alias  => 'stingray_request_key',
        require => Exec['new_stingray_cluster']
    }

    file_line { "public key.${name}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!public %zeushome%/conf/ssl/server_keys/${name}.public",
        require => File['stingray_public_key'],
        notify  => Exec['replicate_config']
    } ->
    file_line { "private key.${name}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!private %zeushome%/zxtm/conf/ssl/server_keys/${name}.private",
        require => File['stingray_private_key'],
        notify  => Exec['replicate_config']
    } ->
    file_line { "request file.${name}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!request %zeushome%/zxtm/conf/ssl/server_keys/${name}.request",
        require => File['stingray_private_key'],
        notify  => Exec['replicate_config']
    } ->
    file_line { "createdvia.${name}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!createdvia ${createdvia}",
        require => File['stingray_private_key'],
        notify  => Exec['replicate_config']
    } ->
    file_line { "protection.${name}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!protection ${protection}",
        require => File['stingray_private_key'],
        notify  => Exec['replicate_config']
    } ->
    file_line { "managed.${name}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!managed yes",
        require => File['stingray_private_key'],
        notify  => Exec['replicate_config']
    } ->
    file_line { "note.${name}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!note ${note}",
        require => File['stingray_private_key'],
        notify  => Exec['replicate_config']
    }
}
