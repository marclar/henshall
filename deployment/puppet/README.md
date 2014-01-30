### Deployment with [Puppet](http://puppetlabs.com)

#### Puppet Child

Install puppet on the hubot child server with:

    wget http://apt.puppetlabs.com/puppetlabs-release-quantal.deb
    dpkg -i puppetlabs-release-quantal.deb
    apt-get update
    apt-get install puppet -y

Set puppet to auto-start with:

    sed --in-place 's/START=no/START=yes/' /etc/default/puppet

Configure the puppet master in `/etc/puppet/puppet.conf` under the [main]
section add:

    server = puppet-master-hostname
    report = true
    pluginsync = true
    certname = hubot-hostname
    certificate_revocation = false

**Note** you _must_ use a host name here (not an IP address)

Start puppet on the hubot child server with:

    puppet resource service puppet ensure=running enable=true

#### Puppet Master

Install puppet on the master server with:

     apt-get install puppetmaster -y

Configure `/etc/puppet/puppet.conf` under the [main] section add:

    server = puppet-master-hostname
    report = true
    pluginsync = true
    certname = puppet-master-hostname

**Note** you _must_ use a host name here (not an IP address)

Start puppet on the master server with:

    puppet resource service puppetmaster ensure=running enable=true

#### Cert Signing

Trigger a cert request from the child with:

    puppet agent --test

On master, view and accept this cert request with:

    puppet cert list
    puppet cert sign --all

**Note** use `puppet cert clean --all` to revoke all certs on the master server

#### Configuring

On the puppet master, install these additional puppet modules necessary this ]
hubot deployment to work:

    puppet module install puppetlabs/nodejs
    puppet module install puppetlabs/vcsrepo

Copy `./deployment/puppet/hubot` to `/etc/puppet/modules/hubot` on the master
server.

    scp -r ./deployment/puppet/hubot
    puppet-master-hostname:/etc/puppet/modules/hubot

Edit `/hubot/manifests/init.pp` and set the configuration you would like for
your bot.

On puppet child, kick off the agent (either daemonized or once off) e.g.;

    puppet agent --test
    # or to launch daemon
    puppet agent

This will install, configure and start hubot running on the child node.

#### Helpful links

* [Learn Puppet](https://puppetlabs.com/learn)
* [Puppet Docs](http://docs.puppetlabs.com)
