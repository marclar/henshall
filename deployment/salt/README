### Deploying with Salt

* create master node first

    curl -L http://bootstrap.saltstack.org | sudo sh -s -- -M -N

* create child node (hubot host)

    wget -O - http://bootstrap.saltstack.org | sh

* edit /etc/salt/minion and add

    master: [master ip or hostname]

* trigger cert requests from child

    salt-minion -l debug

* on master accept with

    salt-key -A

* finally on master, scp the srv folder to /srv

* edit settings in /srv/pillar/hubot-settings.sls and run this sls with

    salt '*' state.sls hubot
