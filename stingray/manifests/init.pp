# == Class: stingray
#
# This class will download and install the Stingray Traffic Manager
# onto a node.
#
# === Parameters
#
# [*tmp_dir*]
# Temp directory to use during installation.  Defaults to '/tmp'.
#
# [*install_dir*]
# Directory on the target node to install the Stingray software to.
# Defaults to '/usr/local/stingray/'.
#
# [*version*]
# The version of Stingray to install.  Defaults to '9.1'.
#
# [*accept_license*]
# Use of this software is subject to the terms of the Riverbed End User
# License Agreement
#
# Please review these terms, published at http://www.riverbed.com/license
# before proceeding.
#
# Set this to 'accept' once you have read the license.
#
# [*installation_source*]
# If you host your own copy of the STM image on a web server, you can specify
# a custom URL to install from. This will override anything specified in the
# "version" parameter.
#
# === Examples
#
#  class { 'stingray':
#      accept_license => 'accept'
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
class stingray (
  $tmp_dir = $stingray::params::tmp_dir,
  $install_dir = $stingray::params::install_dir,
  $version = $stingray::params::version,
  $accept_license = $stingray::params::accept_license,
  $installation_source = undef

) inherits stingray::params {

  if !defined(Package['wget']) {
    package {
      'wget':;
    }
  }

  Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
  $stm_arch = $stingray::params::stm_arch

  #
  # This block of code will format the URL to download the Stingray
  # installer based on $version.
  #
  if $installation_source {
    $image_loc = $installation_source
    } else {
      if $stm_arch == 'x86' {
        case $version {
          '9.1':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=3qlkgtaiptpaqf52mj9tkuafap'}
          '9.1r2': {$image_loc = 'https://support.riverbed.com/download.htm?sid=m2jvm5n98f9v669poctejv597a'}
          '9.2':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=c3p4mfun7mplgnnj3lto889e2s'}
          '9.3':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=jvrmms6hm502u6jv11ij9vk92s'}
          '9.3r1': {$image_loc = 'https://support.riverbed.com/download.htm?sid=9esd1sqo1eqr4vsde24jr3eeut'}
          '9.4':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=seinh554d2ku21084es3l0ssgr'}
          '9.5':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=apehpa9084mt0q3o00q13ef07o'}
          default: { fail("Version ${version} is not supported.  Supported versions are 9.1 till 9.5") }
        }
        } else {
          case $version {
            '9.1':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=c26o2rd0sn2d46m9nlkb8lc2u4'}
            '9.1r2': {$image_loc = 'https://support.riverbed.com/download.htm?sid=mg1k8t5ib0t1ejh9f62jbp2li6'}
            '9.2':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=1d4quq8su3kuhaoor93mlb104d'}
            '9.3':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=qbr1k45ualc3gijn0qavnjaei7'}
            '9.3r1': {$image_loc = 'https://support.riverbed.com/download.htm?sid=t01dd49gtrl85lqus3q7md6qkl'}
            '9.4':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=biuhlvmnlt3jna7kq8ab2u69jk'}
            '9.5':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=faudva1r9hrbcie5a6b509aoti'}
            '9.6':   {$image_loc = 'https://support.riverbed.com/download.htm?sid=vdg19dt684868npc3fggd750pn'}
            '9.6r1': {$image_loc = 'https://support.riverbed.com/bin/support/download?sid=9c3387134vofrjui9e6osj1h1g'}
            '9.7':   {$image_loc = 'https://support.riverbed.com/bin/support/download?sid=tmedbt7phjf2g69b22cesdkb4g'}
            '9.8':   {$image_loc = 'https://support.riverbed.com/bin/support/download?sid=b1rnr2r4fvo7t6jdsrgolb8qeu'}
            '9.8r1': {$image_loc = 'https://support.riverbed.com/bin/support/download?sid=irte05ss3m60br45h8o2vt37l9'}
            '9.8r2': {$image_loc = 'https://support.riverbed.com/bin/support/download?sid=p2rmalibflneacije5b4sdac2q'}
            default: { fail("Version ${version} is not supported.  Supported versions are 9.1 till 9.8r2") }
          }
        }
    }
    #$image_loc = "https://support.riverbed.com/download.htm?filename=public/software/stingray/trafficmanager/${version}"
    $temp_ver = regsubst($version, '(.*)\.(.*)', '\1\2')
    $image_name = "ZeusTM_${temp_ver}_Linux-${stingray::params::stm_arch}"

    #
    # Download from Riverbed Support site and place in $tmp_dir
    #
    exec { "wget ${image_loc} -O ${tmp_dir}/${image_name}.tgz":
      creates => "${tmp_dir}/${image_name}.tgz",
      require => [Package[wget], ],
      alias   => 'wget_stingray',
    }

    #
    # Untar and Ungzip the Stingray installer
    #
    exec { "tar zxvf ${tmp_dir}/${image_name}.tgz":
      cwd     => $tmp_dir,
      creates => "${tmp_dir}/${image_name}/",
      require => [ Exec['wget_stingray'], ],
      alias   => 'untar_stingray',
    }

    #
    # Create the installer script
    #
    file { "${tmp_dir}/${image_name}/install_script":
      content => template('stingray/stingray_install.erb'),
      require => [ Exec['untar_stingray'], ],
      alias   => 'create_install_script',
    }

    #
    # And finally install the software
    #
    exec { "${tmp_dir}/${image_name}/zinstall --replay-from=install_script --noninteractive":
      cwd     => $tmp_dir,
      user    => 'root',
      creates => "${install_dir}/zxtm-${version}",
      require => [ File['create_install_script'], ],
      alias   => 'install_stingray',
    }

    #
    # Set up a process to replicate config to other Stingray
    # Traffic Managers in the cluster when necessary
    #
    stingray::replicate_config{'replicate_config':
      require => Exec['install_stingray']
    }

    #
    # The next step is either create a new_cluster or join_cluster
    #
    }
