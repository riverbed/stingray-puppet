# == Define: del_rule
#
# Deletes a TrafficScript rule from the Stingray Traffic Manager catalog.
 
#
# === Parameters
#
# [*name*]
# The name of the TrafficScript rule to delete from the catalog.
#
# === Examples
#
#  stingray::del_rule { 'My rule':
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
define stingray::del_rule() {
    include stingray

    $path = $stingray::install_dir

    info ("Deleting Rule ${name}")
    file { "${path}/zxtm/conf/rules/${name}":
        ensure => 'absent'
    }
}
