# == Define: del_monitor
#
# Delete a Stingray Traffic Manager monitor class.  Monitors watch the
# nodes in a pool, and inform Stingray if the nodes are functioning
# correctly. They work by sending small requests that expect a set reply.
# If they don't receive the reply they want, the test fails and Stingray
# is notified.
#
# === Parameters
#
# [*name*]
# The name of the monitor class to delete.
#
# === Examples
#
#  stingray::del_monitor { 'My Monitor':
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
define stingray::del_monitor() {
    include stingray

    $path = $stingray::install_dir

    info ("Deleting Monitor ${name}")
    file { "${path}/zxtm/conf/monitors/${name}":
        ensure => 'absent',
    }
}
