# == Define: bandwidth
#
# Creates a Stingray Traffic manager bandwidth management class.  Bandwidth
# classes are used to limit the network resources that a set of connections
# can consume.  When applied to a pool, they limit the bandwidth sending
# data to that pool.  When applied to a virtual server, they limit the
# bandwidth sending data to the clients.
#
# === Parameters
#
# [*maximum*]
# The maximum bandwidth to allocate to connections that are associated
# with this bandwidth class (in kbits/second).
#
# [*sharing*]
# The scope of the bandwidth class.
#
# Valid valuies are:
#    'connection': Each connection can use the maximum rate
#    'machine': Bandwidth is shared per traffic manager
#    'cluster': Bandwidth is shared across all traffic managers
#
# The default value is 'cluster'.
#
# === Examples
#
# stingray::bandwidth { 'My Bandwidth Class':
#   maximum => '10000',
# }
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
#
define stingray::bandwidth (
    $maximum,
    $sharing = 'cluster'
) {

    include stingray

    $path   = $stingray::install_dir

    info("Creating bandwidth class ${name}")
    file { "${path}/zxtm/conf/bandwidth/${name}":
        content => template('stingray/bandwidth.erb'),
        require => [ Exec['new_stingray_cluster'], ],
        notify  => Exec['replicate_config']
    }
}
