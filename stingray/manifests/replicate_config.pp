# == Define: replicate_config
#
# Replicate configuration across the entire cluster.  This will be called
# automatically when a resource is changed and should not be called manually.
#
# === Parameters
#
# === Examples
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
#
# === Copyright
#
# Copyright 2013 Riverbed Technology
#
define stingray::replicate_config() {
    include stingray

    $path = $stingray::install_dir

    exec { "${path}/zxtm/bin/replicate-config --timeout 20":
        alias       => 'replicate_config',
        refreshonly => true
    }
}
