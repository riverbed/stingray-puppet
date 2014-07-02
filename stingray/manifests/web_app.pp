# == Define: web_app
#
# Use Stingray Traffic Manager to manage a web application.
#
# === Parameters
#
# [*name*]
# The name of the web application.
#
# [*nodes*]
# An list of the nodes in host:port format.
#
# [*failpool_nodes*]
# An list of the failure pool nodes in host:port format.
# If all of the nodes in your pool have failed, requests can be diverted
# to a failure pool. 
# The default is to not use a failure pool.
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
# [*algorithm*]
# The Load Balancing algorithm to use.  The default is Least Connections.
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
# [*trafficips*]
# The Traffic IP Address associated with this web application.
#
# [*machines*]
# A list of the Stingray Traffic Managers to associate with the trafficips.
#
# Valid values are:
#    '*'  all Stingray Traffic Managers in the cluster.
#    A list of Stingray Traffic Managers to associate with this Traffic IP Group
#
# The default is .*., all Stingray Traffic Managers in the cluster.
#
# [*port*]
# The port this web application uses.  This must be a numerical
# value, it cannot be '*'.  The default is '80'.
#
# [*ssl_decrypt*]
# Should SSL traffic be decrypted for this web application?  This offloads SSL
# processing from your nodes, and allows the Stingray Traffic Manager to inspect
# and process the connection.  The default is 'no'.

# [*ssl_port*]
# When ssl_decrypt is enabled, the port this web application uses for SSL traffic.  This must be
# a numerical value, it cannot be '*'.  The default is '443'.
#
# [*certificate_file*]
# When ssl_decrypt is enabled, the path to the PEM encoded certificate file
#
# [*private_key_file*]
# When ssl_decrypt is enabled, the path to the PEM encoded private key file. The Private key must not
# be encrypted. You can use openssl to unencrypt the key:
#
#   openssl rsa -in key.private
#
# [*monitor_path*]
# For the health monitor, the path to use. This must be a string beginning
# with a / (forward slash).  The default value is '/'.
#
# [*status_regex*]
# For the health monitor, a regular expression that the status code must match. If the
# status code doesn't matter then set this to .* (match anything).
# The default value is '^[234][0-9][0-9]$'.
#
# [*body_regex*]
# For the heatlh monitor, a regular expression that the response body must match. If the
# response body content doesn't matter then set this to .* (match anything).
# The default value is '.*'.
#
# [*persistence_type*]
# The session persistence type to use.  The default is 'Transparent Session Affinity', which is
# also known as cookie based persistence.
#
# [*caching*]
# If set to 'yes' the Stingray Traffic Manager will attempt to cache web
# server responses. The default is 'yes'.
#
# [*compression*]
# If set to 'yes' the Stingray Traffic Manager will attempt to compress
# content it returns to the browser. The default is 'yes'.
#
# [*compression_level*]
# If compression is enabled, the compression level (1-9, 1=low, 9=high).
# The default is '9'.
#
# [*banned_ips*]
# A list of banned IPs.  The entries can be of the form
# '10.0.1.0/255.255.255.0', '10.0.1.0/24', '10.0.1.' or '10.0.1.1'.
#
# [*aptimizer_express*]
# Aptimizer Express is an add-on module for Stingray Traffic Manager that
# provides a set of robust optimizations to accelerate the delivery of
# most web pages, no configuration or tuning is required. This advanced
# capability with Stingray Aptimizer Express is available as a licensed
# add-on module for Stingray Traffic Manager 9.5 and later.
#
# [*enabled*]
# Enable this web application to begin handling traffic?  The default is 'yes'.
#
# === Examples
#
#  stingray::web_app { 'My Web Application':
#        nodes      => ['192.168.22.121:80', '192.168.22.122:80'],
#        trafficips => '192.168.1.1'
#  }
#
#  stingray::web_app { 'My Other Web Application':
#        nodes            => ['192.168.22.121:80', '192.168.22.122:80'],
#        trafficips       => '192.168.1.1',
#        ssl_decrypt      => 'yes',
#        certificate_file => 'puppet:///modules/stingray/cert.public',
#        private_key_file => 'puppet:///modules/stingray/cert.private'
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
define stingray::web_app(
  $nodes,
  $failpool_nodes    = '',
  $trafficips,
  $weightings        = undef,
  $disabled          = '',
  $draining          = '',
  $algorithm         = 'Least Connections',
  $machines          = '*',
  $port              = '80',
  $ssl_decrypt       = 'no',
  $ssl_port          = '443',
  $certificate_file  = '',
  $private_key_file  = '',
  $monitor_path      = '/',
  $status_regex      = undef,
  $body_regex        = '.*',
  $persistence_type  = 'Transparent Session Affinity',
  $compression       = 'yes',
  $compression_level = '9',
  $caching           = 'yes',
  $enabled           = 'yes',
  $banned_ips        = '',
  $aptimizer_express = 'no',
) {
  include stingray

  $path = $stingray::install_dir

  stingray::persistence { "${name} persist":
    type => $persistence_type
  }

  stingray::monitor { "${name} monitor":
    type         => 'HTTP',
    path         => $monitor_path,
    body_regex   => $body_regex,
    status_regex => $status_regex,
  }

  if ($banned_ips != '') {
    $protection = "${name} protection"
    stingray::protection { $protection:
      banned => $banned_ips
    }
    } else {
      $protection = undef
    }

    stingray::trafficipgroup { "${name} tip":
      ipaddresses => $trafficips,
      machines    => $machines,
      enabled     => $enabled
    }

    if ($failpool_nodes == '') {
      stingray::pool { "${name} pool":
        nodes       => $nodes,
        weightings  => $weightings,
        algorithm   => $algorithm,
        persistence => "${name} persist",
        monitors    => "${name} monitor"
      }
    } else {
      stingray::pool { "${name} failpool":
        nodes       => $failpool_nodes,
        algorithm   => $algorithm,
        monitors    => "${name} monitor"
      }
      stingray::pool { "${name} pool":
        nodes        => $nodes,
        failure_pool => "${name} failpool",
        weightings   => $weightings,
        algorithm    => $algorithm,
        persistence  => "${name} persist",
        monitors     => "${name} monitor"
      }
    }

    stingray::virtual_server { "${name} virtual server":
      address           => "!${name} tip",
      protocol          => 'HTTP',
      port              => $port,
      pool              => "${name} pool",
      caching           => $caching,
      compression       => $compression,
      compression_level => $compression_level,
      protection        => $protection,
      enabled           => $enabled,
      aptimizer_express => $aptimizer_express
    }

    if ($ssl_decrypt == 'yes') {
      stingray::virtual_server { "${name} ssl virtual server":
        address           => "!${name} tip",
        protocol          => 'HTTP',
        port              => $ssl_port,
        pool              => "${name} pool",
        caching           => $caching,
        compression       => $compression,
        compression_level => $compression_level,
        protection        => $protection,
        ssl_decrypt       => 'yes',
        enabled           => $enabled,
        aptimizer_express => $aptimizer_express
      }

      stingray::ssl_certificate { "${name} SSL Certificate":
        certificate_file => $certificate_file,
        private_key_file => $private_key_file
      }
    }
}
