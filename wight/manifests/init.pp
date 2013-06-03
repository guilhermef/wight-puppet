# == Define: wight
#
# Creates a wight server running on 0.0.0.0:8080 by default
#
# === Parameters
#
# [*user*]
#   User to run and install wight and supervisor
#   defaul: root
# [*group*]
#   Group to run and install wight and supervisor
#   defaul: root
# [*conf_path*]
#   Path where the config file will be created
#   defaul: /etc/$title
# [*conf_file*]
#   Config file name and extension
#   defaul: $title.conf
# [*config_param*]
#   Params tha will populate wight.
#   Params can be lowercase like: {mongo_host => '10.2.0.1'}
#   It's automatically transformed to uppercase
#   defaul: {number_of_forks => $::processorcount}
# [*wight_version*]
#   wight version to be used
#   defaul: latest
#
# === Examples
#
# wight {'my-wight-server':
# }
#
# === Authors
#
# Guilherme Souza <guivideojob@gmail.com>
#
# === Copyright
#
# Copyright 2013 Guilherme Souza
#

define wight (
  $user='root',
  $group='root',
  $conf_path="/etc/${title}",
  $conf_file="${title}.conf",
  $config_params={number_of_forks => $::processorcount},
  $wight_version='latest',
  $wight_type='api',
  ) {

  include wight::libgit

  if ! defined(Class['supervisor']) {
    class {'supervisor':
      user => $user
    }
  }

  if ! defined(File[$conf_path]) {
    file{ $conf_path:
      ensure => directory,
      owner => $user,
      group => $group,
      mode => 0755
    }
  }

  if ! defined(File["${conf_path}/${conf_file}"]) {
    file{ "${conf_path}/${conf_file}":
      owner => $user,
      group => $group,
      mode => 0755,
      content => template('wight/sample.conf.erb'),
      require => File[$conf_path]
    }
  }

  if ! defined(Package['wight']) {
    package{'wight':
      ensure => $wight_version,
      provider => 'pip'
    }
  }

  supervisor::service { $title:
    ensure => 'present',
    enable => true,
    command => "wight-${wight_type} -c ${conf_path}/${conf_file}",
    environment => 'LD_LIBRARY_PATH=/usr/local/lib',
    user => $user,
    group => $group,
    require => [File["${conf_path}/${conf_file}"], Package['wight'], Class['wight::libgit']]
  }
}
