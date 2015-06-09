# == Define: settings
#
# Configure Stingray Traffic Manager Security and Global Settings.
#
# === Parameters
#
# [*controlallow*]
# The hosts that can contact the internal administration port on each
# Stingray Traffic Manager. This should be a list containing IP
# addresses, CIDR IP subnets, and localhost; or it can be set to
# 'all' to allow any host to connect. Defaults to 'all'.
#
# [*errlog*]
# The file to log event messages to. Defaults to '%zeushome%/zxtm/log/errors',
# where %zeushome% is where the Stingray software is installed.
# Defaults to '/usr/local/stingray/'.
#
# [*java_enabled*]
# Whether or not Java support should be enabled. If this is set to 'no',
# then your Stingray Traffic Manager will not start any Java processes.
# Java support is only required if you are using the TrafficScript
# java.run() function. Defaults to 'yes'.
#
# [*flipper_autofailback*]
# Whether or not traffic IPs automatically move back to machines that
# have recovered from a failure and have dropped their Traffic IPs.
# Defaults to 'yes'.
#
# [*flipper_frontend_check_addrs*]
# The IP addresses used to check front-end connectivity. Set this to
# an empty string if the traffic manager is on an Intranet with no
# external connectivity. Defaults to '%gateway%'.
#
# [*flipper_monitor_interval*]
# The frequency (in milliseconds) that each Stingray Traffic Manager
# machine should check and announce its connectivity.
# Defaults to '500' milliseconds.
#
# [*flipper_monitor_timeout*]
# How long (in seconds) each Stingray Traffic Manager should wait
# for a response from its connectivity tests or from other Stingray
# Traffic Manager machines before registering a failure.
# Defaults to '5' seconds.
#
# [*ts_variable_pool_use*]
# Allow TraffisCript to use pool variables
# Default is 'No'
#
# === Examples
#
#  stingray::settings { 'My Settings':
#      java_enabled => 'yes',
#      controlallow => 'all'
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
define stingray::settings(
    $controlallow = 'all',
    $errlog = '%zeushome%/zxtm/log/errors',
    $java_enabled = 'Yes',
    $flipper_autofailback = 'Yes',
    $flipper_frontend_check_addrs = '%gateway%',
    $flipper_monitor_interval = 500, # in milliseconds
    $flipper_monitor_timeout = 5, # in seconds
    $flipper_unicast_port = 9090,
    $ts_variable_pool_use = 'No'
) {
    include stingray

    $path = $stingray::install_dir

    file { "${path}/zxtm/conf/settings.cfg":
        content => template ('stingray/settings.erb'),
        require => Exec['new_stingray_cluster']
    }
}
