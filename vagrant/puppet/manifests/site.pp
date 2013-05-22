import "default"

node 'wight.worker.vagrant.com' inherits 'BaseNode' {
  wight{'wight-worker':
    wight_type => 'worker',
    config_params => {'mongo_host' => "'33.33.33.35'",
                      'mongo_port' => '27017'}
  }
}

node 'wight.vagrant.com' inherits 'BaseNode' {
  wight{'wight-web':
    wight_type => 'web',
    config_params => {'mongo_host' => "'33.33.33.35'",
                      'mongo_port' => '27017'}
  }

  wight{'wight-api':
    wight_type => 'worker',
    config_params => {'mongo_host' => "'33.33.33.35'",
                      'mongo_port' => '27017'}
  }
}

node 'wight.resources.vagrant.com' {
  class { 'mongodb':
    bind_ip => '33.33.33.35',
    template => 'mongodb/mongodb.conf.erb'
  }
}