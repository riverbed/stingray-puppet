# == Define: local_user
#
# Local Users are Stingray Admin Server user accounts managed internally
# by the traffic manager software.
#
# === Parameters
#
# [*status*]
# Is this user 'Active' or 'Suspended'.
# The default value is 'Active'.
#
# [*group*]
# Which permission group the user belongs to.  See permission_group.pp
# for more details on permission groups.  Permission groups define
# access privileges.
# The default value is 'admin'.
#
# [*password*]
# The hashed password for this user.  To generate a hashed password:
# openssl passwd -1
#
# [*clear_pw*]
# The password in the [*password*] is a clear password.  If this is set
# to 'Yes' then the hash will be automatically created from the
# clear password.
# The default value is 'No'.
#
# [*salt*]
# The salt to use when *clear_pw* is set to 'Yes'.
# The default value is 'RVBD'.
#
# [*use_applet*]
# Enable the Admin Server UI traffic monitoring applet.
# The default value is 'Yes'.
#
# [*applet_max_vs*]
# The maximum number of virtual server traffic bars to show in the applet.
# The default value is '5'.
#
# [*trafficscript_editor*]
# Use the advanced TrafficScript editor when modifying rules.
# This adds automatic line numbering, syntax highlighting and indentation.
# The default value is 'Yes'.
#
# === Examples
#
#  stingray::local_user { 'my_user':
#        password => '$1$XoqDzcQr$tGjDcW2Fm2VfdsH6zeqrz.'
#  }
#
#  stingray::local_user { 'my_other_user':
#        password => 'password',
#        clear_pw => 'yes',
#        group    -> 'Monitoring'
#  }
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
#
# === Copyright
#
# Copyright 2014 Riverbed Technology
#
define stingray::local_user(
  $password,
  $clear_pw             = 'No',
  $salt                 = 'RVBD',
  $use_applet           = 'yes',
  $applet_max_vs        = 5,
  $trafficscript_editor = 'yes',
  $group                = 'admin',
  $status               = 'Active'
) {
  include stingray

  $path = $stingray::install_dir

  # Convert the Status to a code that Stingray understands
  case downcase($status) {
    'active':      {$status_code = '1'}
    'suspended':   {$status_code = '2'}
    default:       {$status_code = '1'}
  }

  if downcase($clear_pw) == 'no' {
    $pw_hash = $password
    } else {
      $pw_hash = generate('/bin/sh', '-c', "openssl passwd -salt ${salt} -1 ${password}")
    }

    info ("Configuring user ${name}")
    concat::fragment { "${path}/zxtm/conf/user_${name}":
      target  => "${path}/zxtm/conf/users",
      content => template ('stingray/users.erb'),
      require => [ Exec['new_stingray_cluster'], ],
      notify  => Exec['replicate_config']
    }
}
