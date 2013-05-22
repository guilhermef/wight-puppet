node 'BaseNode' {
  user { 'puppet':
    comment => "puppet user",
    managehome => 'true',
    shell => "/bin/bash",
    gid => 'admin',
    password  => '$1$YoVwRnRv$oMYM6TfT5lAcmHxb295RX/'
  }

  package {'python-pip':
  }

  # sudoers::group { 'admin':
  #   ensure => present,
  #   nopasswd => true,
  #   commands => "ALL",
  #   require => User['puppet']
  # }
}