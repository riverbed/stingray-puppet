# == Define: trafficipgroup
#
# Create a Stingray Traffic Manager Traffic IP Group. A traffic IP group
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
# [*ipaddresses*]
# The IP Address associated with this traffic ip group.
#
# [*machines*]
# A list of the Stingray Traffic Managers to associate with this traffic
# ip group. The default is all nodes in the cluster.
#
# [*passive*]
# Of the Stingray Traffic Managers associate with this traffic ip group,
# which are passive?  Stingray Traffic managers in passive mode won't
# have any IP addresses assigned to them unless a failure has occurred.
#
# [*keeptogether*]
# If set to 'yes' then all the traffic IPs will be raised on a single
# Stingray Traffic Manager. The default is 'no' which means the traffic IPs
# are distributed across all active Stingray Traffic Managers in the
# traffic ip group.
#
# [*enabled*]
# Enable this traffic ip group and raise all the IP Addresses?  The default
# is 'no'.
#
# === Examples
#
#  stingray::trafficipgroup { 'My Traffic IP Group':
#      ipaddress => ['192.168.1.1', '192.168.1.2'],
#      machines  => ['my stm', 'my stm 2'],
#      passive   => 'my stm 2',
#      enabled   => 'yes'
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
define stingray::trafficipgroup(
    $ipaddresses = undef,
    $enabled = 'no',
    $machines = '*',
    $passive = '',
    $keeptogether = 'no'

) {
    include stingray

    $path = $stingray::install_dir

    if ($machines == '') {
        if ($::fqdn) {
            $tip_machines = $::fqdn
        } else {
            $tip_machines = $::hostname
        }
    } elsif ($machines == '*') {
        $tip_machines = ''
    } else {
        $tip_machines = $machines
    }

    file { "${path}/zxtm/conf/flipper/${name}":
    }

    file { "${path}/zxtm/conf/flipper/.${name}":
        ensure  => present,
        content => template ('stingray/trafficipgroup.erb'),
        require => Exec['new_stingray_cluster']
    }

    exec { "${path}/zxtm/bin/puppet_tip.sh \"${path}\" \"${name}\" ${tip_machines}":
        path    => '.:/bin:/usr/bin:/bin:/usr/sbin:/sbin',
        require => [ File["${path}/zxtm/conf/flipper/.${name}"],]
    }
}
