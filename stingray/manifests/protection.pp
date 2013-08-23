# == Define: protection
#
# Creates a Stingray Traffic manager protection class. This is like an
# ACL and can be applied to a Virtual server
#
# === Parameters
#
# [*name*]
# Name of the protection class
#
# [*ensure*]
# Ensures the protection class is available or not
#
# [*allowed*]
# List of allowed IP addresses
#
# [*banned*]
# A list of banned IP
#
# === Examples
#
# stingray::protection { 'my_protection_class':
#   allowed => ['10.0.0.0/16', '192.168.1.2'],
#   banned  => ['127.0.0.1'],
# }
#
# === Authors
#
# Ed Lim <limed@mozilla.com>
#
define stingray::protection (
    $ensure     = 'present',
    $allowed    = undef,
    $banned     = ['0.0.0.0/0']
) {

    include stingray

    if ! ($ensure in ['present', 'absent']) {
        fail("${ensure} is not a valid parameter")
    }

    if $ensure == 'present' {
        $file_ensure    = 'file'
    }
    else {
        $file_ensure    = 'absent'
    }

    $path   = $stingray::install_dir
    info("Creating protection class ${name}")

    file { "${path}/zxtm/conf/protection/${name}":
        ensure  => $file_ensure,
        owner   => root,
        group   => root,
        mode    => '0600',
        content => template('stingray/protection.erb'),
    }
}
