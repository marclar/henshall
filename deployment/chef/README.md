### Deploying with Chef

#### Read me first

* The master server requires 1GB of RAM, any lower and the install will fail :(
* Chef master, workstation and children must all be able to access each other
  from real resolvable host names.
* For the purposes of this guide, the workstation was my local mac laptop.

#### Getting Started

First, install the Chef master server. Find out which package to install [from
  here](http://www.getchef.com/chef/install/). For Ubuntu Linux I used:

    wget
    https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.10-1.ubuntu.12.04_amd64.deb
    dpkg -i  chef-server_11.0.10-1.ubuntu.12.04_amd64.deb chef-server-ctl
    reconfigure

Set up a Chef workstation again you can get instructions [from
here](http://www.getchef.com/chef/install/). For OSX I used:

    curl -L https://www.opscode.com/chef/install.sh | sudo bash
    # clone the base chef repo somewhere
    git clone git://github.com/opscode/chef-repo.git ~/chef-hubot

On your workstation, setup certs and permissions from the Chef master server:

    mkdir -p ~/chef-hubot/.chef
    scp root@chef-master:/etc/chef-server/admin.pem  ~/chef-hubot/.chef/
    scp root@chef-master:/etc/chef-server/chef-validator.pem  ~/chef-hubot/.chef/
    knife configure --initial
    # follow the questions, choosing defaults, configuring paths for these pem files
    # test the user was created OK with this knife command
    knife user list

This creates a new admin user on the master server you can login to the Chef
admin interface at https://chef-master:443

From the workstation, install Chef on the hubot child node with this simple one
liner (the hubot child node is a blank slate at this stage):

    knife bootstrap hubot-hostname -x root

Note, that chef uses `hostname --fqdn` on the child node to determine its host
name, so you must have a proper hostname setup on the node for this to work.

On your workstation copy the hubot cookbook from `./deployment/chef/hubot` to
`~/chef-hubot/.chef/cookbooks/hubot`

Edit `~/chef-hubot/.chef/cookbooks/hubot/attributes/default.rb` and set hubot
options.

Upload the cookbook and supporting files to the master server

    knife cookbook upload -a

Add the cookbook to the hubot server run list

    knife node run_list add hubot-hostname 'hubot'

Now you can wait 30 mins (or so) for the run list to be applied to the hubot
server, _OR_ force it to run right now with this command on the hubot child:

    chef-client

Chef should install, configure and start hubot.  After all that, take a break
and have a cup of tea!

#### Helpful links

* [Chef Docs](http://docs.opscode.com)
* [Chef Quick Overview](http://docs.opscode.com/chef_quick_overview.html)
