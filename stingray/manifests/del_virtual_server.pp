# == Define: del_virtual_server
#
# Delete a Stingray Traffic Manager virtual server.  A virtual server
# accepts network traffic and processes it. It normally gives each
# connection to a pool; the pool then forwards the traffic to a server node.
#
# === Parameters
#
# [*name*]
# The name of the virtual server to delete.
#
# === Examples
#
#  stingray::del_virtual_server { 'My Virtual Server':
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
define stingray::del_virtual_server() {
    include stingray

    $path = $stingray::install_dir

    info ("Deleting virtual server ${name}")
    file { "${path}/zxtm/conf/vservers/${name}":
        ensure => 'absent',
    }
}
