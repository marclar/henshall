class hubot {

  Exec { path => '/bin:/sbin:/usr/bin:/usr/sbin' }

  include nodejs

  $options = {
    hubot_name       => 'henshall',
    hubot_adapter    => 'irc',
    campfire_account => '',
    campfire_rooms   => '',
    campfire_token   => '',
    irc_server       => 'irc.perl.org',
    irc_rooms        => '#henshall',
  }

  package { 
    'build-essential':  
      ensure => 'installed';
    'git-core':  
      ensure => 'installed';
    'redis-server':
      ensure => 'installed';
    'coffee':
      ensure   => 'present',
      provider => 'npm';
  }

  service { 'redis-server':
    ensure  => 'running', 
    require => Package['redis-server'],
  }

  exec { 'hubot git repo':
    command => 'git clone https://github.com/matthutchinson/henshall.git /usr/local/hubot',
    creates => '/usr/local/hubot',
  }

  exec { 'hubot dependencies':
    command => 'npm install',
    cwd     => '/usr/local/hubot',
    unless  => 'test -d /usr/local/hubot/node_modules',
    require => Package['coffee'],
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
    ensure    => 'running',
    require   => [ Package['coffee'], File['/etc/init/hubot.conf'] ],
    subscribe => File['/etc/init/hubot.conf'],
  }
}
