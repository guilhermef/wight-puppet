import "default"


$wight_conf = {'mongo_host' => "'33.33.33.35'",
               'mongo_port' => '27017',
               'redis_host' => "'33.33.33.35'",
               'redis_port' => '6379'}


node 'wight.worker.vagrant.com' inherits 'BaseNode' {
  wight{'wight-worker':
    wight_type => 'worker',
    config_params => $wight_conf
  }
}

node 'wight.vagrant.com' inherits 'BaseNode' {
  wight{'wight-web':
    wight_type => 'web',
    config_params => $wight_conf
  }

  wight{'wight-api':
    wight_type => 'api',
    config_params => $wight_conf
  }
}

node 'wight.resources.vagrant.com' {
  class { 'mongodb':
    bind_ip => '33.33.33.35',
    template => 'mongodb/mongodb.conf.erb'
  }

  class {'redis':
      version => '2.6.13',
      redis_max_memory => '256mb'
  }
}