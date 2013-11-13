# == Define: monitor
#
# Create a Stingray Traffic Manager monitor class.  Monitors watch the
# nodes in a pool, and inform Stingray if the nodes are functioning
# correctly. They work by sending small requests that expect a set reply.
# If they don't receive the reply they want, the test fails and Stingray
# is notified.
#
# === Parameters
#
# [*name*]
# The name of the monitor class.
#
# [*type*]
# The base type of the monitor to create.
#
# Valid values are:
#    'Ping': This pings the target machine at specified intervals.
#    'TCP Connect': This makes a TCP connection with the target machine,
#                   to check that a server is listening on the port.
#    'HTTP': This sends an HTTP request to the target server, optionally
#            using SSL, with specified parameters such as host header and
#            the URL path to use. It searches for a status code regex in
#            the response.
#    'TCP Transaction': This performs a TCP transaction with the target
#                       machine, with an optional string of data to write
#                       to the connection. It can look for a specified regex
#                       in the response.
#    'SIP': This sends a SIP request to the target server of a specified
#           transport type. It searches for a regex-matching status code
#           and body in the response.
#    'RTSP': This sends a RTSP request to the target server with a
#            specified path. It searches for a regex-matching status
#            code and body in the response.
#
# The default value is 'Ping'.
#
# [*scope*]
# A monitor can either monitor each node in the pool separately and
# disable an individual node if it fails, or it can monitor a specific
# machine and disable the entire pool if that machine fails.
#
# Valid values are:
#    'Node': Monitor each node in the pool separately
#    'Pool': Monitor a specific machine and disable the entire pool if
#            that machine fails.  When using this monitor, a 'machine'
#            to monitor must be specified.
#
# [*machine*]
# When the *scope* is set to 'Pool', the hostname or ip address of the
# machine to monitor.  Where relevant this should be in the form
# <hostname/ip>:<port>, for "ping" monitors the :<port> part must not
# be specified.
#
# [*delay*]
# The minimum time (in seconds) between calls to a monitor. This controls
# how often a monitor runs, increasing this time will slow the monitor down.
# The default value is '3' seconds.
#
# [*timeout*]
# The time (in seconds) in which a monitor must complete. If it takes
# longer than this, the monitor run will be classed as having failed.
# The default value is '3' seconds.
#
# [*failures*]
# The number of consecutive runs that must fail before a node is
# marked as failed. Once this number of failures has occurred, Stingray
# will be notified and an alert message will be raised.
# The default value is '3' runs.
#
# [*use_ssl*]
# Whether or not the monitor should connect using SSL?  The default is 'no'.
# Only applicable to HTTP, TCP Transaction, SIP, and RTSP monitors.
#
# [*status_regex*]
# A regular expression that the status code must match. If the
# status code doesn't matter then set this to .* (match anything).
# The default value is '^[234][0-9][0-9]$'.
# Only applicable to 'HTTP', 'SIP', and 'RTSP' monitors.
#
# [*body_regex*]
# A regular expression that the response body must match. If the
# response body content doesn't matter then set this to .* (match anything).
# Only applicable to 'HTTP', 'SIP', and 'RTSP' monitors.
#
# [*path*]
# The path to use in the test request. This must be a string beginning
# with a / (forward slash).  The default value is '/'.
# Only applicable to 'HTTP' and 'RTSP' monitors.
#
# [*host_header*]
# The host header to use in the test HTTP request.  The default value is none.
# Only applicable to 'HTTP' monitors.
#
# [*authentication*]
# The HTTP basic-auth <user>:<password> to use for the test HTTP request.
# The default is none.
# Only applicable to 'HTTP' monitors.
#
# [*write_string*]
# The string to write down the TCP connection.
# Only applicable to 'TCP Transaction' monitors.
#
# [*response_regex*]
# A regular expression to match against the response from the server.
# Only applicable to 'TCP Transaction' monitors.
#
# [*close_string*]
# An optional string to write to the server before closing the connection.
# Only applicable to 'TCP Transaction' monitors.
#
# [*sip_transport*]
# Which transport protocol the SIP monitor will use to query the server,
# either 'UDP' or 'TCP'? The default value is 'UDP'
# Only applicable to 'SIP' monitors.
#
# [*udp_accept_all*]
# If *sip_transport* is set to UDP, should it accept responses from
# any IP and port?  The default value is 'no'.
# Only applicable to 'SIP' monitors.
#
# === Examples
#
#  stingray::monitor { 'My Monitor':
#      type    => 'Ping',
#      scope   => 'Pool',
#      machine => '192.168.1.1'
#  }
#
#  stingray::monitor { 'My HTTP Monitor':
#      type       => 'HTTP',
#      body_regex => '.*',
#      path       => '/test'
#  }
#
#  stingray::monitor { 'My TCP Transaction Monitor':
#      type         => 'TCP Transaction',
#      write_string => 'My string',
#      use_ssl      => 'yes'
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
define stingray::monitor(
    $type = 'ping',
    $scope = 'node',
    $machine = undef,
    $delay = undef,
    $timeout = undef,
    $failures = undef,
    $use_ssl = 'no',
    $status_regex = undef,
    $body_regex = undef,
    $path = undef,
    $host_header = undef,
    $authentication = undef,
    $write_string = undef,
    $response_regex = undef,
    $close_string = undef,
    $sip_transport = undef,
    $udp_accept_all = undef

) {
    include stingray

    $install_dir = $stingray::install_dir

    # Convert the Type to a code that Stingray understands
    case downcase($type) {
        'ping': {
            $type_code = 'ping'
            $can_use_ssl = 'no'
            $editable_keys = undef
        }
        'tcp connect': {
            $type_code = 'connect'
            $can_use_ssl = 'no'
            $editable_keys = undef
        }
        'http': {
            $type_code = 'http'
            $can_use_ssl = 'yes'
            $editable_keys = ['host_header', 'path', 'authentication',
                              'status_regex', 'body_regex']
        }
        'tcp transaction': {
            $type_code = 'tcp_transaction'
            $can_use_ssl = 'yes'
            $editable_keys = ['write_string','response_regex', 'close_string']
        }
        'sip': {
            $type_code = 'sip'
            $can_use_ssl = 'yes'
            $editable_keys = ['sip_transport', 'sip_status_regex',
                              'sip_body_regex', 'udp_accept_all']
        }
        'rtsp': {
            $type_code = 'rtsp'
            $can_use_ssl = 'yes'
            $editable_keys = ['rtsp_path', 'rtsp_status_regex',
                              'rtsp_body_regex']
        }
        default: {
            $type_code = downcase($type)
            $can_use_ssl = undef
            $editable_keys = undef
        }
    }

    # Convert the Scope to a code that Stingray understands
    case downcase($scope) {
        'node':            {$scope_code = 'pernode'}
        'pool':            {$scope_code = 'poolwide'}
        default:           {$scope_code = downcase($scope)}
    }

    file { "${install_dir}/zxtm/conf/monitors/${name}":
        content => template ('stingray/monitor.erb'),
        require => [ Exec['new_stingray_cluster'], ],
        notify  => Exec['replicate_config']
    }
}
