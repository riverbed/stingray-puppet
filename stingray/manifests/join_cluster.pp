# == Define: join_cluster
#
# Join an existing Stingray Traffic Manager cluster.
#
# === Parameters
#
# [*name*]
# The name of the cluster.  This is ignored here.
#
# [*join_cluster_host*]
# Host name for a Stingray Traffic Manager in the cluster to join.
#
# [*join_cluster_port*]
# The admin console port for the cluster.  This defaults to '9090'.
#
# [*admin_username*]
# The administrator username of the cluster.  Defaults to 'admin'.
#
# [*admin_password*]
# The administrator password of the cluster.  Defaults to 'password'.
#
# [*license_key*]
# Path to the license key file. Providing no license key file, defaults to
# developer mode.
#
# === Examples
#
#  stingray::join_cluster { 'my_cluster':
#      join_cluster_host => 'The other STM',
#      admin_password    => 'my_password',
#      license_key       => 'puppet:///modules/stingray/license.txt
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
define stingray::join_cluster (
    $join_cluster_host = undef,
    $join_cluster_port = '9090',
    $admin_username = $stingray::params::admin_username,
    $admin_password = $stingray::params::admin_password,
    $license_key = $stingray::params::license_key
) {
    include stingray
    include stingray::params

    $path = $stingray::install_dir
    $accept_license = $stingray::accept_license

    file { $path:
        ensure => present,
        alias  => 'join_cluster_stingray_installed',
    }

    if ($license_key != '') {
        file { "${path}/license.txt":
            source  => $license_key,
            before  => [ File['join_stingray_cluster_replay'], ],
            alias   => 'join_cluster_stingray_license',
        }
        $local_license_key = "${path}/license.txt"
    }

    file { "${path}/join_cluster_replay":
        content => template ('stingray/join_cluster.erb'),
        require => [ File['join_cluster_stingray_installed'], ],
        alias   => 'join_stingray_cluster_replay',
    }

    exec { "${path}/zxtm/configure --replay-from=join_cluster_replay":
        cwd     => $path,
        user    => 'root',
        require => [ File['join_stingray_cluster_replay'], ],
        alias   => 'join_stingray_cluster',
        creates => "${path}/rc.d/S10admin",
    }

    if ($license_key == '') {
        if ($::fqdn) {
	    $host = $::fqdn
        } else {
	    $host = $::hostname
        }
        
        file_line { 'developer_license_accepted':
            ensure  => present,
            path    => "${path}/zxtm/conf/zxtms/${host}",
            line    => 'developer_mode_accepted yes',
            require => [ Exec['join_stingray_cluster'], ],
        }
    }
}
