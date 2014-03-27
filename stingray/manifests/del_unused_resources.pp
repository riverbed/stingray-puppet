# == Define: del_unused_resources
#
# Delete unused Stingray Traffic Manager virtual server, pools, traffic ip groups, etc.
# This should not be called manually.
#
# === Parameters
#
# === Examples
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
#
# === Copyright
#
# Copyright 2013 Riverbed Technology
#
define stingray::del_unused_resources() {
    include stingray

    $path = $stingray::install_dir

    info ('Deleting unused resources')
    file { "${path}/zxtm/conf/licensekeys/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/rules/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/persistence/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/protection/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/bandwidth/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/monitors/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/vservers/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/pools/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/flipper/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/ssl/server_keys/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    file { "${path}/zxtm/conf/groups/":
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        notify  => Exec['replicate_config']
    }

    #
    # There are some built in monitors that need to be preserved
    #
    file { "${path}/zxtm/conf/monitors/Full HTTPS":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/Full HTTP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/Simple HTTP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/Simple HTTPS":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/Client First":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/Server First":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/Ping":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/FTP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/SIP TCP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/SIP UDP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/SIP TLS":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/RTSP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/SMTP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/DNS":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/POP":
        ensure  => 'present',
    }

    file { "${path}/zxtm/conf/monitors/Connect":
        ensure  => 'present',
    }

    #
    # There are some built in groups that need to be preserved
    #
    file { "${path}/zxtm/conf/groups/admin":
        ensure  => 'present',
    }
    file { "${path}/zxtm/conf/groups/Demo":
        ensure  => 'present',
    }
    file { "${path}/zxtm/conf/groups/Guest":
        ensure  => 'present',
    }
    file { "${path}/zxtm/conf/groups/Monitoring":
        ensure  => 'present',
    }
}
