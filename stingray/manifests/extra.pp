# == Define: extra
#
# Import an extra file to the Stingray Traffic Manager catalog.
#
# === Parameters
#
# [*name*]
# The name to give the extra file  being imported to the catalog.
#
# [*file*]
# The file source
#
# === Examples
#
#  stingray::extra { 'My extra file':
#      file => 'puppet:///modules/stingray/extra_file.html'
#  }
#
# === Authors
#
# Arnaud MATHIEU (https://github.com/mathiear)
#
define stingray::extra(
    $file = '',

) {
    include stingray

    $path = $stingray::install_dir

    info ("Import extra file ${name}")
    file { "${path}/zxtm/conf/extra/${name}":
        ensure => 'present',
        source => $file,
        notify => Exec['replicate_config']
    }
}
