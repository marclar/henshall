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

hubot-git-repo:
  git.latest:
    - name: https://github.com/matthutchinson/henshall.git
    - target: /usr/local/hubot

hubot-dependencies:
  cmd:
    - run
    - cwd: /usr/local/hubot
    - name: npm install

hubot-user:
  user:
    - present
    - name: hubot
    - groups:
      - hubot
  group:
    - present

/var/log/hubot.log:
  file:
    - managed
    - user: hubot
    - group: hubot
    - mode: 644

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
