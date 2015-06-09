# == Define: virtual_server
#
# Create a Stingray Traffic Manager virtual server.  A virtual server
# accepts network traffic and processes it. It normally gives each
# connection to a pool; the pool then forwards the traffic to a server node.
#
# === Parameters
#
# [*name*]
# The name of the virtual server.
#
# [*address*]
# The IP Address for this virtual server to listen on.
#
# Valid values are:
#     - '*' which means to listen to all IP Addresses on this host.
#     - A list of Traffic IP Groups prepended with an '!'.
#       For example: address => ['!TIP 1', '!TIP 2'],
#     - A list of IP Address and/or domain names.  The virtual server will
#       take all the traffic on its port for all domain names and IPs listed.
#
# The default value is '*' (listen to all IP Addresses).
#
# [*port*]
# The port this virtual server listens on.  This must be a numerical
# value, it cannot be '*'.  The default is '80'.
#
# [*protocol*]
# The protocol your clients and back-end nodes use. Setting it correctly
# will allow protocol-specific features, such as rules that edit this
# protocol's headers, to work properly. The default value is 'HTTP'.
#
# Valid values are:
#    'HTTP'        'Telnet'             'DNS (TCP)'
#    'FTP'         'SSL'                'SIP (UDP)'
#    'IMAPv2'      'SSL (HTTPS)'        'SIP (TCP)'
#    'IMAPv3'      'SSL (POP3S)'        'RTSP'
#    'IMAPv4'      'SSL (LDAPS)'        'Generic Server First'
#    'POP3'        'UDP -Streaming'     'Generic Client First'
#    'SMTP'        'UDP'                'Generic Streaming'
#    'LDAP'        'DNS (UDP)'
#
# If you're not sure, use 'Generic Streaming'.  The default valus is 'HTTP'.
#
# [*pool*]
# The name of the pool to associate with this virtual server. The default
# pool is 'discard' which drops all traffic.  See pool.pp for more information
# on pools.
#
# [*protection*]
# The service protection class to use.  Service protection is similar to an ACL
# that defines IP address that are banned and allowed.
#
# [*bandwidth*]
# The bandwidth management class to use. Bandwidth classes are used to
# limit the network resources that a set of connections can consume.
# When applied to a virtual server, they limit the bandwidth sending
# data to the clients.
#
# [*enabled*]
# Enable this virtual server to begin handling traffic?  The default is 'no'.
#
# [*ssl_decrypt*]
# Should this virtual server decrypt SSL traffic?  This offloads SSL
# processing from your nodes, and allows the virtual server to inspect
# and process the connection.  The default is 'no'.
#
# [*ssl_certificate*]
# The name of the SSL certificate to use when decrypting SSL connections.
# See ssl_certificate.pp for more information on importing SSL
# certificates for use with the Stingray Traffic Manager.
#
# [*request_rules*]
# If a request rule is needed, the name of the rule to use. See rule.pp for
# creating # a rule.
#
# [*response_rules*]
# If a response rule is needed, the name of the rule to use. See rule.pp for
# creating a rule.
#
# [*enable_logging*]
# Should this virtual server log all requests? The default is 'no'.
#
# [*log_filename*]
# If enable_logging is set to 'yes', the name of the file in which to store
# the request logs.
#
# [*caching*]
# If set to 'yes' the Stingray Traffic Manager will attempt to cache web
# server responses. The default is 'no'.
#
# [*compression*]
# If set to 'yes' the Stingray Traffic Manager will attempt to compress
# content it returns to the browser. The default is 'no'.
#
# [*compression_level*]
# If compression is enabled, the compression level (1-9, 1=low, 9=high).
# The default is '1'.
#
# [*timeout*]
# A connection should be closed if no additional data has been received
# for this period of time. A value of 0 (zero) will disable this timeout.
# Note that the default value may vary depending on the protocol selected.
#
# [*connect_timeout*]
# The time, in seconds, to wait for data from a new connection. If no data
# is received within this time, the connection will be closed. A value
# of 0 (zero) will disable the timeout.
# The default is '10'.
#
# [*aptimizer_express*]
# Aptimizer Express is an add-on module for Stingray Traffic Manager that
# provides a set of robust optimizations to accelerate the delivery of
# most web pages, no configuration or tuning is required. This advanced
# capability with Stingray Aptimizer Express is available as a licensed
# add-on module for Stingray Traffic Manager 9.5 and later.
#
# [*rc_save_all*]
# set line recent_conns!save_all
# Default is undef
#
# === Examples
#
#  stingray::virtual_server { 'My Virtual Server':
#      address => '!My Traffic IP',
#      pool    => 'My Pool',
#      enabled => 'yes',
#  }
#
#  stingray::virtual_server { 'My SSL Virtual Server':
#      address         => '!My Traffic IP',
#      protocol        => 'HTTP',
#      port            => 443,
#      pool            => 'My Pool',
#      enabled         => 'yes',
#      ssl_decrypt     => 'yes',
#      ssl_certificate => 'My SSL Certificate'
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
define stingray::virtual_server(
  $address             = '*',
  $port                = 80,
  $protocol            = 'http',
  $pool                = 'discard',
  $protection          = undef,
  $bandwidth           = undef,
  $enabled             = 'no',
  $ssl_decrypt         = 'no',
  $ssl_certificate     = undef,
  $request_rules       = undef,
  $response_rules      = undef,
  $enable_logging      = false,
  $log_filename        = '%zeushome%/zxtm/log/%v.log',
  $caching             = 'no',
  $compression         = 'no',
  $compression_level   = undef,
  $timeout             = undef,
  $connect_timeout     = undef,
  $aptimizer_express   = 'no',
  $rc_save_all         = undef,
  $error_file          = undef
) {
  include stingray

  $path = $stingray::install_dir
  $version = $stingray::version

  # Convert the Protocol to a code that Stingray understands
  case downcase($protocol) {
    'ssl (https)':          {$proto_code = 'https'}
    'ssl (imaps)':          {$proto_code = 'imaps'}
    'ssl (pop3s)':          {$proto_code = 'pop3s'}
    'ssl (ldaps)':          {$proto_code = 'ldaps'}
    'udp - streaming':      {$proto_code = 'udpstreaming'}
    'dns (udp)':            {$proto_code = 'dns'}
    'dns (tcp)':            {$proto_code = 'dns_tcp'}
    'sip (udp)':            {$proto_code = 'sipudp'}
    'sip (tcp)':            {$proto_code = 'siptcp'}
    'generic server first': {$proto_code = 'server_first'}
    'generic client first': {$proto_code = 'client_first'}
    'generic streaming':    {$proto_code = 'stream'}
    default:                {$proto_code = downcase($protocol)}
  }

  if $version =~ /9\.[1-4](r[1-9]|$)/ {
    warning ("Aptimizer Express requires Stingray Traffic Manager version 9.5 or later, you are running version ${version}")
    $aptimizer_express_code = 'no'
    } else {
      $aptimizer_express_code = $aptimizer_express
    }

    info ("Configuring virtual server ${name}")
    file { "${path}/zxtm/conf/vservers/${name}":
      content => template ('stingray/virtual_server.erb'),
      require => [ Exec['new_stingray_cluster'], ],
      notify  => Exec['replicate_config']
    }
}
