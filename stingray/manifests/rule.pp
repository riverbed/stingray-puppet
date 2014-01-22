# == Define: rule
#
# Import a TrafficScript rule to the Stingray Traffic Manager catalog.
#
# === Parameters
#
# [*name*]
# The name to give the TrafficScript rule being imported to the catalog.
#
# [*file*]
# The file containing the rule
#
# === Examples
#
#  stingray::rule { 'My rule':
#      file => 'puppet:///modules/stingray/rule.ts'
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
define stingray::rule(
    $file = '',

) {
    include stingray

    $path = $stingray::install_dir

    info ("Import rule ${name}")
    file { "${path}/zxtm/conf/rules/${name}":
        ensure => 'present',
        source => $file,
        notify => Exec['replicate_config']
    }
}
