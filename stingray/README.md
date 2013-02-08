# Riverbed Stingray Traffic Manager module for Puppet

Riverbed Stingray Traffic Manager is a full performance software and virtual Layer 7 application delivery controller (ADC) that enables enterprises and cloud operators to create, manage, and deliver key services more quickly, more flexibly, and at a lower cost.

This module installs Riverbed Stingray Traffic Manager and manages virtual servers, pools, traffic ip groups, etc.

## Installation

The modules can be installed via puppet module tool (require [version 2.7.14+](http://docs.puppetlabs.com/puppet/2.7/reference/modules_installing.html)):

    puppet module install riverbed/stingray

## Usage

Parameters:

* install_dir: Directory to install the Stingray software tou (default: /usr/local/stingray/).
* version: The version of Stingray to install (default: 9.1).
* tmp_dir: Temp directory to use during installation (default: /tmp).
* accept_license: Use of this software is subject to the terms of the [Riverbed End User License Agreement](http://www.riverbed.com/license).  Set this to to 'accept' once you have read the license (default: reject).

Example:

    class stingray {
        accept_license => 'accept'
    }

That will download and install the Stingray Traffic Manager.

### new_cluster
After the sofware is installed you can either create a new cluster or join an existing cluster (see below).  To create a new cluster:

    stingray::new_cluster { 'My cluster':
    }

### join_cluster
To join an existing Stingray cluster:

    stingray::join_cluster { 'my_cluster':
        join_cluster_host => 'The other STM',
        admin_password    => 'my_password'
    }

### pool
A pool manages a group of server nodes.  To manage pools:

    stingray::pool { 'My Pool':
        nodes => ['192.168.22.121:80', '192.168.22.122:80']
    }

### trafficipgroup
A traffic ip group defines the set of IP address that the Stingray Traffic Manager will be listening on.  To manage traffic ip groups:

    stingray::trafficipgroup { 'My Traffic IP Group':
        ipaddress => ['192.168.1.1', '192.168.1.2'],
        machines  => 'My STM',
        enabled   => 'yes',
    }

### virtual_server
A virtual server accepts network traffic and processes it.  To manage virtual servers:

    stingray::virtual_server { 'My Virtual Server':
        address => '!My Traffic IP',
        pool    => 'My Pool',
        enabled => 'yes',
    }

## Other notes
Supported functionality includes managing:

* Virtual Servers
* Pools
* Traffic IP Groups
* Monitors
* Persistence
* SSL Certificates
* Global Settings
