# == Define: new_cluster
#
# Create a new Stingray Traffic Manager cluster.
#
# === Parameters
#
# [*name*]
# The name of the new cluster.
#
# [*admin_password*]
# The administrator password to use.  Defaults to 'password'.
#
# [*license_key*]
# Path to the license key file. Providing no license key file, defaults to
# developer mode.
#
# === Examples
#
#  stingray::new_cluster { 'my_cluster':
#  }
#
#  stingray::new_cluster { 'my_cluster':
#      admin_password => 'my_password',
#      license_key    => 'puppet:///modules/stingray/license.txt'
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
define stingray::new_cluster (
  $admin_password = $stingray::params::admin_password,
  $license_key = $stingray::params::license_key

) {
  include stingray
  include stingray::params

  $path = $stingray::install_dir
  $accept_license = $stingray::accept_license


  file { "${path}/new_cluster_replay":
    content => template ('stingray/new_cluster.erb'),
    require => [ Exec['install_stingray'], ],
    alias   => 'new_stingray_cluster_replay',
  }

  exec { "${path}/zxtm/configure --replay-from=new_cluster_replay --noninteractive":
    cwd     => $path,
    user    => 'root',
    require => [ File['new_stingray_cluster_replay'], ],
    alias   => 'new_stingray_cluster',
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
        require => [ Exec['new_stingray_cluster'], ],
      }

      file { "${path}/zxtm/conf/licensekeys/license.txt":
        ensure  => absent,
        notify  => Exec['replicate_config'],
        require => [ Exec['new_stingray_cluster'], ],
      }
      } else {
        file { "${path}/zxtm/conf/licensekeys/license.txt":
          ensure  => present,
          source  => $license_key,
          require => [ Exec['new_stingray_cluster'], ],
          alias   => 'new_stingray_cluster_license',
          notify  => Exec['replicate_config']
        }
      }

      file {"${path}/zxtm/bin/puppet_tip.sh":
        mode    => '0755',
        source  => 'puppet:///modules/stingray/puppet_tip.sh',
        require => [ Exec['new_stingray_cluster'], ]
      }

      # Manage users and groups
      concat { "${path}/zxtm/conf/users":
        require => Exec['new_stingray_cluster'],
        notify  => Exec['replicate_config']
      }

      local_user { 'admin':
        password => $admin_password,
        clear_pw => 'yes',
        require  => [ Exec['new_stingray_cluster'], ]
      }

      file { "${path}/zxtm/conf/ssl/server_keys_config":
        ensure  => 'present',
        alias   => 'server_keys_config',
        require => [ Exec['new_stingray_cluster'], ],
      }


      stingray::del_unused_resources{'del_unused_resources':
        require => [ Exec['new_stingray_cluster'], ]
      }
}
