### Deployment with Puppet

#### Puppet Child

Install puppet on the master and hubot servers with;

    wget http://apt.puppetlabs.com/puppetlabs-release-quantal.deb
    dpkg -i puppetlabs-release-quantal.deb
    apt-get update
    apt-get install puppet -y

Set puppet to auto-start on hubot server with;

    sed --in-place 's/START=no/START=yes/' /etc/default/puppet

Configure puppet on hubot server in `/etc/puppet/puppet.conf` under the [main] section add;

    server = puppet-master-hostname
    report = true
    pluginsync = true
    certname = hubot-hostname
    certificate_revocation = false

**Note** you _must_ use a host name here (not an IP address)

Start puppet on the hubot server;

    puppet resource service puppet ensure=running enable=true

#### Puppet Master

Install puppet on master with;

     apt-get install puppetmaster -y

Configure puppet on master server in `/etc/puppet/puppet.conf` under the [main] section;

    server = puppet-master-hostname
    report = true
    pluginsync = true
    certname = puppet-master-hostname

**Note** you _must_ use a host name here (not an IP address)

Start puppet on the master server with;

    puppet resource service puppetmaster ensure=running enable=true

#### Cert Signing

Trigger a cert request from the child with;

    puppet agent --test

On master, view and accept the cert request with;

    puppet cert list
    puppet cert sign --all

**Note** use `puppet cert clean --all` to revoke all certs on master

#### Configuring

On puppet master, install additional puppet modules necessary for this deployment;

    puppet module install puppetlabs/nodejs
    puppet module install puppetlabs/vcsrepo

Copy the `deployment/puppet/hubot` directory in this repo to
`/etc/puppet/modules/hubot`

On puppet child, kick off the agent (either daemonized or once off test) e.g.;

    puppet agent --test
    # or to launch daemon
    puppet agent
