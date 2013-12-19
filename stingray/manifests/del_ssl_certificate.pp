# == Define: del_ssl_certificate
#
# Deletes an SSL Certificate from the Stingray Traffic Manager catalog.
#
# === Parameters
#
# [*name*]
# The name of the SSL Certificate to delete from the catalog.
#
# === Examples
#
#  stingray::del_ssl_certificate { 'My SSL Certificate':
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
define stingray::del_ssl_certificate() {
    include stingray

    $path = $stingray::install_dir

    info ("Deleting SSL certificate ${name}")
    file { "${path}/zxtm/conf/ssl/server_keys/${name}.public":
        ensure => 'absent'
    }

    file { "${path}/zxtm/conf/ssl/server_keys/${name}.private":
        ensure => 'absent'
    }

    file { "${path}/zxtm/conf/ssl/server_keys_config":
        ensure => 'present',
        alias  => 'server_keys_config'
    }

    file_line {'public key':
        ensure  => 'absent',
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!public  ${path}/zxtm/conf/ssl/server_keys/${name}.public",
        require => File['server_keys_config']
    }

    file_line {'private key':
        ensure  => 'absent',
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!private  ${path}/zxtm/conf/ssl/server_keys/${name}.private",
        require => File['server_keys_config']
    }

    file_line {'managed':
        ensure  => 'absent',
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${name}!managed  yes",
        require => File['server_keys_config']
    }
}
