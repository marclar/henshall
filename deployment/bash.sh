# install build essentials, redis (for the brain) and git
apt-get update
apt-get install build-essential vim git redis-server --assume-yes

# install (latest) node (includes npm)
mkdir /usr/local/src/node-latest
cd /usr/local/src/node-latest
curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
./configure && make && make install
cd ~/

# install coffee-script
npm install -g coffee-script

# clone hubot from git
git clone https://github.com/matthutchinson/henshall.git /usr/local/hubot
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
env HUBOT_CAMPFIRE_ACCOUNT=''
env HUBOT_CAMPFIRE_ROOMS=''
env HUBOT_CAMPFIRE_TOKEN=''
env HUBOT_IRC_SERVER=''
env HUBOT_IRC_ROOMS=''
env HUBOT_IRC_NICK=''
env HUBOT_IRC_UNFLOOD='true'

# Subscribe to these upstart events
# This will make Hubot start on system boot
start on filesystem or runlevel [2345]
stop on runlevel [!2345]

# Path to Hubot installation
env HUBOT_DIR='/usr/local/hubot'
env HUBOT_LOG_FILE='/var/log/hubot.log'
env HUBOT_BIN='bin/hubot'
env HUBOT_ADAPTER='campfire'
env HUBOT_USER='hubot'
env HUBOT_NAME='henshall'

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
