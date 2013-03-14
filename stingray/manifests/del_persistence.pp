# == Define: del_persistence
#
# Delete a Stingray Traffic Manager session persistence class.  Session
# persistence classes can be used to direct all requests in a client
# session to the same node. This may be necessary for complex applications,
# where an application session may be maintained over a number of
# separate connections. Examples of this include web-based shopping carts,
# and many complex UDP-based protocols.
#
# === Parameters
#
# [*name*]
# The name of the session persistence class to delete.
#
# === Examples
#
#  stingray::del_persistence { 'My Persistence':
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
define stingray::del_persistence() {
    include stingray

    $path = $stingray::install_dir

    info ("Deleting persistence ${name}")
    file { "${path}/zxtm/conf/persistence/${name}":
        ensure => 'absent'
    }
}
