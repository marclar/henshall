# Tested with Ubuntu 12.10 (ymmv with other distribs)

# wget https://github.com/matthutchinson/henshall/blob/master/deployment/hubot.sh
# [edit file, setting adapter, bot name and other variables]
# chmod 755 ./bash.sh && ./bash.sh
# dependencies will install and bot starts running (logs to /var/log/hubot.log)

# some vars
HUBOT_ADAPTER="irc"
HUBOT_NAME="henshall"
HUBOT_REPO="https://github.com/matthutchinson/henshall.git"

HUBOT_CAMPFIRE_ACCOUNT=''
HUBOT_CAMPFIRE_ROOMS=''
HUBOT_CAMPFIRE_TOKEN=''
HUBOT_IRC_SERVER='irc.perl.org'
HUBOT_IRC_ROOMS='#henshall'

# install build essentials, redis (for the brain) and git
apt-get update
apt-get install build-essential git-core redis-server python-software-properties software-properties-common --assume-yes

# install (latest) node (builds from source (slow) and includes npm)
add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install nodejs --assume-yes

# install coffee-script
npm install -g coffee-script

# clone hubot from git
git clone $HUBOT_REPO /usr/local/hubot
cd /usr/local/hubot
npm install

# hubot user
adduser --disabled-password --gecos "" hubot

touch /var/log/hubot.log
chown hubot:hubot /var/log/hubot.log

# upstart script
cat <<EOF > /etc/init/hubot.conf
description "Hubot"

# campfire adapter variables
env HUBOT_CAMPFIRE_ACCOUNT='$HUBOT_CAMPFIRE_ACCOUNT'
env HUBOT_CAMPFIRE_ROOMS='$HUBOT_CAMPFIRE_ROOMS'
env HUBOT_CAMPFIRE_TOKEN='$HUBOT_CAMPFIRE_TOKEN'
env HUBOT_IRC_SERVER='$HUBOT_IRC_SERVER'
env HUBOT_IRC_ROOMS='$HUBOT_IRC_ROOMS'
env HUBOT_IRC_NICK='$HUBOT_NAME'
env HUBOT_IRC_UNFLOOD='true'

# Subscribe to these upstart events
# This will make Hubot start on system boot
start on filesystem or runlevel [2345]
stop on runlevel [!2345]

# Path to Hubot installation
env HUBOT_DIR='/usr/local/hubot'
env HUBOT_LOG_FILE='/var/log/hubot.log'
env HUBOT_BIN='bin/hubot'
env HUBOT_USER='hubot'
env HUBOT_ADAPTER='$HUBOT_ADAPTER'
env HUBOT_NAME='$HUBOT_NAME'

# Keep the process alive, limit to 5 restarts in 60s
respawn
respawn limit 5 60

exec start-stop-daemon --start --chuid \$HUBOT_USER --chdir \$HUBOT_DIR \
  --exec \$HUBOT_DIR/\$HUBOT_BIN -- --name \$HUBOT_NAME --adapter \$HUBOT_ADAPTER >> \$HUBOT_LOG_FILE 2>&1
EOF

# log rotation
cat <<EOF > /etc/logrotate.d/hubot
/var/log/hubot.log {
  daily
  missingok
  rotate 14
  size 50M
  compress
  delaycompress
  notifempty
  create 640 hubot hubot
  sharedscripts
  postrotate
    restart hubot
  endscript
}
EOF

# start the bot
start hubot
