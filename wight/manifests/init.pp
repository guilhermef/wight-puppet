# == Define: wight
#
# Creates a wight server running on 0.0.0.0:8080
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { wight:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
define wight (
  $user='root',
  $group='root',
  $conf_path="/etc/${title}",
  $conf_file="${title}.conf",
  $config_params={number_of_forks => $::processorcount}
  ) {

  file{ $conf_path:
    ensure => directory,
    owner => $user,
    group => $group,
    mode => 0755
  }

  file{ "${conf_path}/${conf_file}":
    owner => $user,
    group => $group,
    mode => 0755,
    content => template('wight/sample.conf.erb'),
    require => File[$conf_path]
  }
}
