# == Define: del_web_app
#
# Delete a Stingray Traffic Manager web application.
#
# === Parameters
#
# [*name*]
# The name of the web application to delete
#
# === Examples
#
#  stingray::del_web_app { 'My Web Application':
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
define stingray::del_web_app() {
    include stingray

    $path = $stingray::install_dir

    stingray::del_persistence { "${name} persist":
    }

    stingray::del_monitor { "${name} monitor":
    }

    stingray::del_trafficipgroup { "${name} tip":
    }

    stingray::del_pool { "${name} pool":
    }

    stingray::del_virtual_server { "${name} virtual server":
    }

    stingray::del_virtual_server { "${name} ssl virtual server":
    }

    stingray::del_ssl_certificate { "${name} SSL Certificate":
    }
}
