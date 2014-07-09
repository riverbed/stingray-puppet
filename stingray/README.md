# Riverbed Stingray Traffic Manager module for Puppet

Riverbed Stingray Traffic Manager is a full performance software and virtual
Layer 7 application delivery controller (ADC) that enables enterprises and cloud
operators to create, manage, and deliver key services more quickly, more
flexibly, and at a lower cost.

This module installs Riverbed Stingray Traffic Manager and manages virtual
servers, pools, traffic ip groups, etc.

[What's new in Version 0.6.0](https://splash.riverbed.com/community/product-lines/steelapp/blog/2014/07/09/whats-new-in-steelapp-puppet-module-060)

## Installation

The modules can be installed via puppet module tool (requires
[version 2.7.14+](http://docs.puppetlabs.com/puppet/2.7/reference/modules_installing.html)):

    puppet module install riverbed/stingray

## Usage

Parameters:

* `install_dir`: Directory to install the Stingray software to
(default: /usr/local/stingray/).
* `version`: The version of Stingray to install (default: 9.1).
* `tmp_dir`: Temp directory to use during installation (default: /tmp).
* `accept_license`: Use of this software is subject to the terms of the
[Riverbed End User License Agreement](http://www.riverbed.com/license).  Set
this to 'accept' once you have read the license (default: reject).

Example:

    class {'stingray':
      accept_license => 'accept',
    }

That will download and install the Stingray Traffic Manager.

### new_cluster
After the sofware is installed you can either create a new cluster or join an
existing cluster (see below).  To create a new cluster:

    stingray::new_cluster { 'My cluster':
    }

### join_cluster
To join an existing Stingray cluster:

    stingray::join_cluster { 'my_cluster':
      join_cluster_host => 'The other STM',
      admin_password    => 'my_password',
    }

### web_app
Use Stingray Traffic Manager to manage a web application

    stingray::web_app { 'My Web Application':
      nodes      => ['192.168.22.121:80', '192.168.22.122:80'],
      trafficips => '192.168.1.1',
    }

### pool
A pool manages a group of server nodes.  To manage pools:

    stingray::pool { 'My Pool':
      nodes => ['192.168.22.121:80', '192.168.22.122:80'],
    }

### trafficipgroup
A traffic ip group defines the set of IP address that the Stingray Traffic
Manager will be listening on.  To manage traffic ip groups:

    stingray::trafficipgroup { 'My Traffic IP Group':
      ipaddresses => ['192.168.1.1', '192.168.1.2'],
      machines    => 'My STM',
      enabled     => 'yes',
    }

### virtual_server
A virtual server accepts network traffic and processes it.  To manage virtual
servers:

    stingray::virtual_server { 'My Virtual Server':
      address => '!My Traffic IP',
      pool    => 'My Pool',
      enabled => 'yes',
    }

### monitor
Monitors watch the nodes in a pool, and inform Stingray if the nodes are
functioning correctly. To create a monitor:

    stingray::monitor { 'My HTTP Monitor':
      type       => 'HTTP',
      body_regex => '.*',
      path       => '/my_path',
    }

### persistence
Session persistence classes can be used to direct all requests in a client
session to the same node. To create a session persistence class:

    stingray::persistence { 'My Persistence':
      type => 'Transparent Session Affinity',
    }

### protection
Creates a Stingray Traffic manager protection class. This is like an ACL and can
be applied to a Virtual Server.

    stingray::protection { 'My Protection Class':
      allowed => ['10.0.0.0/16', '192.168.1.2'],
      banned  => ['127.0.0.1'],
    }

### bandwidth

Creates a Stingray Traffic manager bandwidth management class.  Bandwidth
classes are used to limit the network resources that a set of connections
can consume.  When applied to a pool, they limit the bandwidth sending
data to that pool.  When applied to a virtual server, they limit the
bandwidth sending data to the clients.

    stingray::bandwidth { 'My Bandwidth Class':
      maximum => '10000',
    }

### ssl_certificate
Stingray can be used to offload SSL processing from your servers.  To use this
feature you must import your SSL certificate to the Stingray Traffic Manager.
To import an SSL certificate:

    stingray::ssl_certificate { 'My SSL Certificate':
      certificate_file => 'puppet:///modules/stingray/cert.public',
      private_key_file => 'puppet:///modules/stingray/cert.private',
    }

## Further Reading
Please see the [Reference Guide](https://splash.riverbed.com/docs/DOC-1638) for
more details on all the functionality available with the Stingray Traffic
Manager Puppet Module.
