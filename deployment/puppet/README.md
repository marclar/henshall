### Deployment with Puppet

Install puppet on the master and hubot servers with;

    wget http://apt.puppetlabs.com/puppetlabs-release-quantal.deb
    dpkg -i puppetlabs-release-quantal.deb
    apt-get update

Set puppet to auto-start on hubot server with;

    apt-get install puppet -y
    sed --in-place 's/START=no/START=yes/' /etc/default/puppet

Configure puppet on hubot server in `/etc/puppet/puppet.conf` under the [main] section add;

    server = puppet-master-hostname
    report = true
    pluginsync = true
    certname = hubot-hostname

**Note** you _must_ use a host name here (not an IP address)

Start puppet on hubot server;

    puppet resource service puppet ensure=running enable=true

Install puppet on master with;

     apt-get install puppetmaster -y

Configure puppet on master server in `/etc/puppet/puppet.conf` under the [main] section;

    server = puppet-master-hostname
    report = true
    pluginsync = true
    certname = puppet-master-hostname

**Note** you _must_ use a host name here (not an IP address)

Install additional puppet modules nessecary for this deployment;

    puppet module install puppetlabs/nodejs
    puppet module install puppetlabs/vcsrepo

Start puppet on master server with;

    puppet resource service puppetmaster ensure=running enable=true

Trigger a cert request from the child with;

    puppet agent --test

On master, view and accept the cert request with;

    puppet cert list
    puppet cert sign --all

