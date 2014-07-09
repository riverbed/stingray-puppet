# == Define: permission_group
#
# Create a permission group.  Permission Groups are used to restrict what
# users can do in the SteelApp Traffic Manager.
#
# === Parameters
#
# [*application_firewall*] - [*wizard*]
# You can set access rights to each page within Stingray, and the
# various features on that page, by setting the appropriate flag for
# the current group. Flag settings can be:
#              - 'none' (for no access at all)
#              - 'ro' (for permission to view the data but make no changes)
#              - 'full' (for full rights to view and change data)
# The default value for each page is 'ro' (read only).
#
# [*timeout*]
# Timeout (in minutes) the login after a period of inactivity.
# A value of '0' means never time out.
# The default value is '30' minutes.
#
# [*password_expire_time*]
# Members of this group must renew their passwords after this number
# of days. To disable password expiry for the group set this to 0 (zero).
# Note that this setting applies only to local users.
# The default value is '0'.
#
# === Examples
#
#  stingray::permission_group { 'My Group':
#      persistence => 'full',
#      rules => 'none'
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
define stingray::permission_group(
  $application_firewall = 'ro',
  $alerting             = 'ro',
  $aptimizer            = 'ro',
  $audit_log            = 'ro',
  $authenticators       = 'ro',
  $backup               = 'ro',
  $bandwidth            = 'ro',
  $catalog              = 'ro',
  $cloud_credentials    = 'ro',
  $config_summary       = 'ro',
  $connections          = 'ro',
  $custom               = 'ro',
  $diagnose             = 'ro',
  $draining             = 'ro',
  $event_log            = 'ro',
  $extra_files          = 'ro',
  $glb_services         = 'ro',
  $global_settings      = 'ro',
  $help                 = 'ro',
  $java                 = 'ro',
  $license_keys         = 'ro',
  $locations            = 'ro',
  $log_viewer           = 'ro',
  $main_index           = 'ro',
  $map                  = 'ro',
  $monitoring           = 'ro',
  $monitors             = 'ro',
  $persistence          = 'ro',
  $pools                = 'ro',
  $rate                 = 'ro',
  $reboot               = 'ro',
  $request_logs         = 'ro',
  $restart              = 'ro',
  $rules                = 'ro',
  $slm                  = 'ro',
  $snmp                 = 'ro',
  $soap_api             = 'none',
  $ssl                  = 'ro',
  $security             = 'ro',
  $service_protection   = 'ro',
  $shutdown             = 'ro',
  $statd                = 'ro',
  $steelhead            = 'ro',
  $support              = 'ro',
  $support_files        = 'ro',
  $traffic_ip_groups    = 'ro',
  $traffic_managers     = 'ro',
  $virtual_servers      = 'ro',
  $users                = 'ro',
  $web_cache            = 'ro',
  $wizard               = 'ro',
  $timeout              = 30,
  $password_expire_time = 0
) {
  include stingray

  $path = $stingray::install_dir

  info ("Configuring group ${name}")
  file { "${path}/zxtm/conf/groups/${name}":
    content => template ('stingray/groups.erb'),
    require => [ Exec['new_stingray_cluster'], ],
    notify  => Exec['replicate_config']
  }
}
