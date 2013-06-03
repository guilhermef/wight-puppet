class wight::libgit {
  package { 'git-core':
    ensure => 'present'
  }

  package { 'make':
    ensure => 'present'
  }

  package { 'cmake':
    ensure => 'present'
  }

  exec { 'libgit2_clone':
      cwd => '/usr/local/src',
      command => 'git clone git://github.com/libgit2/libgit2.git',
      creates => '/usr/local/src/libgit2',
      require => Package['git-core'],
      path => ['/usr/bin', '/usr/local/bin', '/bin', '/sbin']
  }

  exec { 'libgit2_make':
      cwd => '/usr/local/src/libgit2',
      user => 'root',
      command => 'mkdir build &&
                  cd build &&
                  cmake .. &&
                  cmake --build . &&
                  ctest . &&
                  cmake --build . --target install &&
                  ldconfig',
      creates => [ '/usr/local/lib/libgit2.so',
                   '/usr/local/include/git2.h' ],
      require => [ Exec['libgit2_clone'],
                   Package['make'], Package['cmake'] ],
      path => ['/usr/bin', '/usr/local/bin', '/bin', '/sbin']
  }

  file { "/etc/profile.d/wight_variables.sh":
    content => "export LD_LIBRARY_PATH=/usr/local/lib"
  }
}
