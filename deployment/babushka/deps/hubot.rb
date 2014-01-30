# Hubot via Babushka
#
# the best way to read this file is from the bottom up, following the babushka
# dependency tree all the way to the top

def hubot_options
  {
    :adapter          => 'irc',
    :name             => 'henshall',
    :repo             => 'https://github.com/matthutchinson/henshall.git',
    :campfire_account => '',
    :campfire_rooms   => '',
    :campfire_token   => '',
    :irc_server       => 'irc.perl.org',
    :irc_rooms        => '#henshall'
  }
end

# adds the add-apt-repository command
dep 'add-apt-repository.bin' do
  requires 'apt'
  meet {
    shell 'apt-get install python-software-properties software-properties-common -y'
  }
  provides 'add-apt-repository'
end

# adds the chirs-lea apt repo and updates apt
dep 'chris-lea apt source' do
  requires 'add-apt-repository.bin'
  met? {
    shell 'apt-cache policy | grep chris-lea\/node\.js'
  }
  meet {
    shell 'add-apt-repository -y ppa:chris-lea/node.js && apt-get update'
  }
end

# installs a recent version of nodejs and npm
dep 'nodejs.bin' do
  requires 'chris-lea apt source'
  installs 'nodejs'
  provides 'nodejs >= 0.10.25', 'npm >= 1.3.24'
end

# installs coffee script via npm
dep 'coffee-script' do
  requires 'nodejs.bin'
  met? {
    shell 'which coffee | grep coffee'
  }
  meet {
    shell 'npm install -g coffee-script'
  }
end

# clones the hubot git repo
dep 'hubot repo' do
  requires 'git'
  met? {
    shell 'test -d /usr/local/hubot'
  }
  meet {
    shell "git clone #{hubot_options[:repo]} /usr/local/hubot"
  }
end

# creates a hubot user (no shell)
dep 'hubot user' do
  met? {
    '/etc/passwd'.p.grep(/^hubot\:/)
  }
  meet {
    shell 'adduser --shell /bin/false hubot'
  }
end

# touchs and sets ownership on the hubot log file
dep 'hubot log file' do
  requires 'hubot user'
  met? {
    '/var/log/hubot.log'.p.exists?
  }
  meet {
    shell 'touch /var/log/hubot.log && chown hubot:hubot /var/log/hubot.log'
  }
end

# adds the hubot logrotate file from the logrotate template
dep 'hubot logrotate', :for => :linux do
  requires 'hubot log file'
  met? {
    '/etc/logrotate.d/hubot'.p.exists?
  }
  meet {
    render_erb 'hubot/logrotate', :to => '/etc/logrotate.d/hubot'
  }
end

# adds hubot upstart template with the hubot_options
dep 'hubot upstart' do
  met? {
    '/etc/init/hubot.conf'.p.exists?
  }
  meet {
    render_erb 'hubot/upstart', :to => '/etc/init/hubot.conf'
  }
end

# installs hubot node modules
dep 'hubot installed' do
  requires 'coffee-script', 'hubot repo', 'hubot logrotate', 'hubot upstart'
  met? {
    shell 'test -d /usr/local/hubot/node_modules'
  }
  meet {
    shell 'cd /usr/local/hubot && npm install'
  }
end

# installs redis server
dep 'redis-server.bin' do
  installs 'redis-server'
  provides 'redis-server'
end

# starts redis server
dep 'redis-server running' do
  requires 'redis-server.bin'
  met? {
    shell 'ps aux | grep [r]edis-server'
  }
  meet {
    shell 'service redis-server start'
  }
end

# starts hubot service (via upstart)
dep 'hubot' do
  requires 'redis-server running', 'hubot installed'
  met? {
    shell 'ps aux | grep coffee.*[h]ubot'
  }
  meet {
    shell 'start hubot'
  }
end
