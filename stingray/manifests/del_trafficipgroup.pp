# == Define: del_trafficipgroup
#
# Delete a Stingray Traffic Manager Traffic IP Group. A traffic IP group
# is a set of IP addresses that will be distributed across a number of
# Stingray Traffic Managers. If a Stingray Traffic Manager fails,
# any IP addresses in the traffic IP group that were assigned to it
# will be redistributed across the remaining traffic managers. This
# provides fault tolerance.
#
# === Parameters
#
# [*name*]
# The name of the traffic ip group.
#
# === Examples
#
#  stingray::del_trafficipgroup { 'My Traffic IP Group':
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
define stingray::del_trafficipgroup() {
    include stingray

    $path = $stingray::install_dir

    info ("Deleting Traffic IP Group ${name}")
    file { "${path}/zxtm/conf/flipper/${name}":
        ensure => 'absent',
    }
}
