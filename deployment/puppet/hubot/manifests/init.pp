class hubot {

  include git

  class { 'nodejs':
    version => 'v0.10.24',
    make_install => false,
  }

  file { '/usr/bin/node':
    ensure => 'link',
    target => '/usr/local/node/node-default/bin/node',
  }

  file { '/usr/bin/npm':
    ensure => 'link',
    target => '/usr/local/node/node-default/bin/npm',
  }

  $options = {
    hubot_name             => 'henshall',
    hubot_adapter          => 'irc',
    hubot_repo             => 'https://github.com/matthutchinson/henshall.git',
    hubot_campfire_account => '',
    hubot_campfire_rooms   => '',
    hubot_campfire_token   => '',
    hubot_irc_server       => 'irc.perl.org',
    hubot_irc_rooms        => '#henshall',
  }

  package {
    'build-essential':
      ensure => 'installed';
    'redis-server':
      ensure => 'installed';
    'coffee':
      ensure   => 'present',
      provider => npm,
      require  => File['/usr/bin/npm'],
  }

  service { 'redis-server':
    ensure  => 'running',
    require => Package['redis-server'],
  }

  vcsrepo { '/usr/local/hubot':
    provider => 'git',
    source   => $options['hubot-repo'],
    revision => 'master',
    owner    => 'hubot',
    group    => 'hubot',
    require  => [ User['hubot'], Package['git'] ],
  }

  exec { 'hubot dependencies':
    command => '/usr/bin/npm install -g',
    cwd     => '/usr/local/hubot',
    unless  => '/usr/bin/test -d /usr/local/hubot/node_modules',
    require => [ File['/usr/bin/npm'], Package['coffee'] ],
  }

  user { 'hubot':
    ensure => 'present',
    shell  => '/bin/false',
  }

  file { '/var/log/hubot.log':
    ensure  => 'present',
    owner   => 'hubot',
    group   => 'hubot',
    mode    => 644,
    require => User['hubot'],
  }

  file { '/etc/logrotate.d/hubot':
    source => 'puppet:///modules/hubot/hubot_logrotate',
    require => File['/var/log/hubot.log'],
  }

  file { '/etc/init/hubot.conf':
    content => template('hubot/hubot_upstart.erb'),
    notify  => Service['hubot']
  }

  service { 'hubot':
    enable    => 'true',
    ensure    => 'running',
    require   => [ Package['coffee'], File['/etc/init/hubot.conf'] ],
    subscribe => File['/etc/init/hubot.conf'],
  }
}
