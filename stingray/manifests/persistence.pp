# == Define: persistence
#
# Create a Stingray Traffic Manager session persistence class.  Session
# persistence classes can be used to direct all requests in a client
# session to the same node. This may be necessary for complex applications,
# where an application session may be maintained over a number of
# separate connections. Examples of this include web-based shopping carts,
# and many complex UDP-based protocols.
#
# === Parameters
#
# [*name*]
# The name of the session persistence class.
#
# [*type*]
# Stingray supports a range of different session persistence methods.
#
# Valid values are:
#    'IP-based': Send all requests from the same source address to
#                the same node.
#    'Universal': Use session persistence data supplied by a TrafficScript rule.
#    'Named Node': Use a node specified by a TrafficScript rule.
#    'Transparent session affinity': Insert cookies into the response
#                                    to track sessions.
#    'Monitor application cookies': Monitor a specified application cookie
#                                   to identify sessions.
#    'J2EE': Monitor Java's JSESSIONID cookie and URLs
#    'ASP': Monitor ASP session cookies and ASP.NET session cookies and
#           cookie-less URLs.
#    'SSL Session ID': Use the SSL Session ID to identify sessions (SSL
#                      pass-through only).
#
# The default value is 'IP-based'.
#
# [*cookie*]
# For the 'Monitor application cookies' persistence type, the name of
# the cookie to monitor.
#
# === Examples
#
#  stingray::persistence { 'My Persistence':
#      type => 'Transparent Session Affinity'
#  }
#
#  stingray::persistence { 'My Other Persistence':
#      type   => 'Monitor application cookies',
#      cookie => 'My cookie'
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
define stingray::persistence(
    $type = 'ip-based',
    $cookie = undef

) {
    include stingray

    $path = $stingray::install_dir

    # Convert the Type to a code that Stingray understands
    case downcase($type) {
        'ip-based':                     {$type_code = 'ip'}
        'universal':                    {$type_code = 'universal'}
        'named node':                   {$type_code = 'named'}
        'transparent session affinity': {$type_code = 'sardine'}
        'monitor application cookies':  {$type_code = 'kipper'}
        'j2ee':                         {$type_code = 'j2ee'}
        'asp':                          {$type_code = 'asp'}
        'ssl session id':               {$type_code = 'ssl'}
        default:                        {$type_code = downcase($type)}
    }

    file { "${path}/zxtm/conf/persistence/${name}":
        content => template ('stingray/persistence.erb'),
        require => [ Exec['new_stingray_cluster'], ],
        notify  => Exec['replicate_config']
    }
}
