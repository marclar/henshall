app-pkgs:
  pkg.installed:
    - names:
      - git-core
      - build-essential
      - software-properties-common
      - python-software-properties

redis-server:
  pkg:
    - installed
  service:
    - running

nodejs-source-add:
  cmd:
    - run
    - name: add-apt-repository -y ppa:chris-lea/node.js && apt-get update
    - unless: test -e /usr/bin/node

nodejs:
  pkg:
    - installed

coffee-script:
  cmd:
    - run
    - name: npm install coffee
    - unless: npm list | grep coffee
    - require:
      - pkg: nodejs

hubot-git-repo:
  git.latest:
    - name: https://github.com/matthutchinson/henshall.git
    - target: /usr/local/hubot

hubot-dependencies:
  cmd:
    - run
    - cwd: /usr/local/hubot
    - name: npm install
    - unless:  test -d /usr/local/hubot/node_modules
    - require:
      - pkg: nodejs

hubot-user:
  user:
    - present
    - name: hubot

/var/log/hubot.log:
  file:
    - managed
    - user: hubot
    - group: hubot
    - mode: 644
    - require:
      - user: hubot-user

/etc/logrotate.d/hubot:
  file:
    - managed
    - source: salt://templates/hubot_logrotate
  
/etc/init/hubot.conf:
  file:
    - managed
    - source: salt://templates/hubot_upstart
    - template: jinja

hubot:
  service:
    - running
    - require:
      - pkg: nodejs
      - pkg: redis-server
      - user: hubot-user
      - cmd: coffee-script
      - cmd: hubot-dependencies
    - watch:
      - file: /etc/init/hubot.conf
