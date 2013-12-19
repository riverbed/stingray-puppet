# == Define: del_pool
#
# Delete a Stingray Traffic Manager pool.  A pool manages a group of
# server nodes. It routes traffic to the most appropriate node, based on
# load balancing and session persistence criteria.
#
# === Parameters
#
# [*name*]
# The name of the pool to delete.
#
# === Examples
#
#  stingray::del_pool { 'My Pool':
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
define stingray::del_pool() {
    include stingray

    $path = $stingray::install_dir

    info ("Deleting pool ${name}")
    file { "${path}/zxtm/conf/pools/${name}":
        ensure => 'absent'
    }
}
