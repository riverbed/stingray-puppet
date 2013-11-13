# == Define: protection
#
# Creates a Stingray Traffic manager protection class. This is like an
# ACL and can be applied to a Virtual Server.
#
# === Parameters
#
# [*name*]
# Name of the protection class
#
# [*allowed*]
# List of allowed IP addresses
#
# [*banned*]
# A list of banned IP addresses
#
# === Examples
#
# stingray::protection { 'My Protection Class':
#   allowed => ['10.0.0.0/16', '192.168.1.2'],
#   banned  => ['127.0.0.1'],
# }
#
# === Authors
#
# Ed Lim <limed@mozilla.com>
#
define stingray::protection (
    $allowed    = undef,
    $banned     = ['0.0.0.0/0']
) {

    include stingray

    $path   = $stingray::install_dir

    info("Creating protection class ${name}")
    file { "${path}/zxtm/conf/protection/${name}":
        owner   => root,
        group   => root,
        mode    => '0600',
        content => template('stingray/protection.erb'),
        require => [ Exec['new_stingray_cluster'], ],
        notify  => Exec['replicate_config']
    }
}
