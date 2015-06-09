# == Define: pool
#
# Create a Stingray Traffic Manager pool.  A pool manages a group of
# server nodes. It routes traffic to the most appropriate node, based on
# load balancing and session persistence criteria.
#
# === Parameters
#
# [*name*]
# The name of the pool.
#
# [*nodes*]
# An list of the nodes in host:port format.
#
# [*weightings*]
# Path to the license key file. Providing no license key file defaults to
# developer mode.
#
# [*disabled*]
# A list of the nodes in host:port format that are disabled.  When a node
# is disabled, all currently established connections to that node will
# be terminated and no further requests will be sent to it.
#
# [*draining*]
# A list of the nodes in host:port format that are draining.  When a node
# is draining, it will not receive any new connections other than those
# in sessions already established. To remove a node from a pool safely,
# it should be drained first.
#
# [*monitors*]
# A list of the monitors for this pool.  A pool can have multiple monitors.
# Monitors watch the nodes in a pool, and inform Stingray if the nodes are
# functioning correctly.  Stingray contains a number of builtin monitors.
# You can also create custom monitors, please see monitor.pp for more
# details on creating custom monitors.  The default monitor for a pool
# is the builtin 'Ping' monitor.
#
# [*algorithm*]
# The Load Balancing algorithm to use.  The default is Round Robin.
#
# Valid values are:
#    'Round Robin':  Assign requests in turn to each node.
#    'Weighted Round Robin':  Assign requests in turn to each node,
#                             in proportion to thieir weights.
#    'Perceptive': Predict the most appropriate node using a combination
#                  of historical and current data.
#    'Least Connections': Assign each request to the node with the
#                         fewest connections
#    'Weighted Least Connections': Assign each request to a node based on the
#                                  number of concurrent connections to the node
#                                  and its weight.
#    'Fastest Response Time': Assign each request to the node with the fastest
#                             response time.
#    'Random Node': Choose a random node for each request.
#
# [*persistence*]
# The Session Persistence class to use for this pool.  Session Persistence
# ensures that all requests from a client will always get sent to the same
# node. The default is to not use Session Persistence.
#
# [*bandwidth*]
# The bandwidth management class to use. Bandwidth classes are used to
# limit the network resources that a set of connections can consume.
# When applied to a pool, they limit the bandwidth sending data to
# that pool.
#
# [*maxconns*]
# The maximum number of concurrent connections allowed to each back-end
# node in this pool per machine. A value of 0 means unlimited connections.
# The default value is 0 (unlimited connections).
#
# [*failure_pool*]
# If all of the nodes in your pool have failed, requests can be diverted
# to a failure pool. 
# The default is to not use a failure pool.
# 
# [*ssl_encrypt*]
# To enable encryption to the backend nodes
#
#
#
# === Examples
#
#  stingray::pool { 'My Pool':
#        nodes => ['192.168.22.121:80', '192.168.22.122:80']
#  }
#
#  stingray::pool { 'My Other Pool':
#        nodes      => ['192.168.22.121:80', '192.168.22.122:80'],
#        weightings => {'192.168.22.121:80' => 1,
#                       '192.168.22.122:80' => 2},
#        algorithm  => 'Least Connections'
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
define stingray::pool(
    $nodes,
    $weightings   = undef,
    $monitors     = 'Ping',
    $disabled     = '',
    $draining     = '',
    $algorithm    = 'Round Robin',
    $persistence  = undef,
    $bandwidth    = undef,
    $failure_pool = undef,
    $maxconns     = undef,
    $ssl_encrypt  = undef,
    $priority     = undef
) {
    include stingray

    $path = $stingray::install_dir

    # Convert the Algortihm to a code that Stingray understands
    case downcase($algorithm) {
        'round robin':                {$alg_code = 'roundrobin'}
        'weighted round robin':       {$alg_code = 'wroundrobin'}
        'perceptive':                 {$alg_code = 'cells'}
        'least connections':          {$alg_code = 'connections'}
        'weighted least connections': {$alg_code = 'wconnections'}
        'fastest response time':      {$alg_code = 'responsetimes'}
        'random':                     {$alg_code = 'random'}
        default:                      {$alg_code = 'roundrobin'}
    }

    info ("Configuring pool ${name}")
    file { "${path}/zxtm/conf/pools/${name}":
        content => template ('stingray/pool.erb'),
        require => [ Exec['new_stingray_cluster'], ],
        notify  => Exec['replicate_config']
    }
}
