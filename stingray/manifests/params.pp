# == Class: params
#
# This class contains default parameters used during Stingray
# installation.
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
#
# === Copyright
#
# Copyright 2013 Riverbed Technology
#
class stingray::params {

    $accept_license     = 'reject'
    $version            = '9.1'
    $install_dir        = '/usr/local/stingray'
    $tmp_dir            = '/tmp'
    $admin_username     = 'admin'
    $admin_password     = 'password'
    $license_key        = ''

    case $::architecture {
        'amd64', 'x86_64':{
            $stm_arch = 'x86_64'
        }
        'i386', 'x86': {
            $stm_arch = 'x86'
        }
        default: {
            fail('Unsupported architecture')
        }
    }

}
