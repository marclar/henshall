dep 'redis-server.bin' do
  installs 'redis-server'
  provides 'redis-server'
end

dep 'redis-server running' do
  requires 'redis-server.bin'
  met? {
    shell "ps aux | grep [r]edis-server"
  }
  meet {
    shell "service redis-server start"
  }
end

dep 'add-apt-repository.bin' do
  requires 'apt'
  meet {
    shell 'apt-get install python-software-properties software-properties-common -y'
  }
  provides 'add-apt-repository'
end

dep 'chris-lea apt source' do
  requires 'apt', 'add-apt-repository.bin'
  met? {
    shell 'apt-cache policy | grep chris-lea\/node\.js'
  }
  meet {
    shell 'apt-get update && add-apt-repository -y ppa:chris-lea/node.js'
  }
end

dep 'nodejs.bin' do
  requires 'chris-lea apt source'
  installs 'nodejs'
  provides 'nodejs >= 0.10.25', 'npm >= 1.3.24'
end

dep 'coffee-script' do
  requires 'nodejs.bin'
  met? {
    shell 'which coffee | grep coffee'
  }
  meet {
    shell 'npm install -g coffee-script'
  }
end

dep 'hubot repo' do
  requires 'git'
  met? {
    shell 'test -d /usr/local/hubot'
  }
  meet {
    shell "git clone https://github.com/matthutchinson/henshall.git /usr/local/hubot"
  }
end

dep 'hubot installed' do
  requires 'coffee-script', 'hubot repo', 'hubot logrotate', 'hubot upstart'
  met? {
    shell 'test -d /usr/local/hubot/node_modules'
  }
  meet {
    shell "cd /usr/local/hubot && npm install"
  }
end

dep 'hubot user' do
  met? {
    '/etc/passwd'.p.grep(/^hubot\:/)
  }
  meet {
    shell 'adduser --shell /bin/false hubot'
  }
end

dep 'hubot log file' do
  requires 'hubot user'
  met? {
    '/var/log/hubot.log'.p.exists?
  }
  meet {
    shell 'touch /var/log/hubot.log && chown hubot:hubot /var/log/hubot.log'
  }
end

dep 'hubot logrotate', :for => :linux do
  requires 'hubot log file'
  met? {
    '/etc/logrotate.d/hubot'.p.exists?
  }
  meet {
    render_erb 'hubot/logrotate', :to => '/etc/logrotate.d/hubot'
  }
end

dep 'hubot upstart' do
  def hubot_options
   {
     'hubot_adapter'    => 'irc',
     'hubot_name'       => 'henshall',
     'campfire_account' => '',
     'campfire_rooms'   => '',
     'campfire_token'   => '',
     'irc_server'       => 'irc.perl.org',
     'irc_rooms'        => '#henshall'
   }
  end

  met? {
    '/etc/init/hubot.conf'.p.exists?
  }
  meet {
    render_erb 'hubot/upstart', :to => '/etc/init/hubot.conf'
  }
end

dep 'hubot running' do
  requires 'redis-server running', 'hubot installed'
  met? {
    shell "ps aux | grep coffee.*[h]ubot"
  }
  meet {
    shell 'start hubot'
  }
end

dep 'hubot' do
  requires 'redis-server running', 'hubot running'
end
