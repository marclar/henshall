### Deploying with Chef

#### Read me first

* The master server requires 1GB of RAM, any lower and the install will fail :(
* For the purposes of this guide, the workstation was my local OSX laptop.
* Chef master, workstation and children must all be able to access each other
  from real resolvable host names.

#### Getting Started

* First, install the Chef master server. Find out which package to install [from
  here](http://www.getchef.com/chef/install/). For Ubuntu Linux I used:

```
wget
https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.10-1.ubuntu.12.04_amd64.deb
dpkg -i  chef-server_11.0.10-1.ubuntu.12.04_amd64.deb chef-server-ctl
reconfigure
```

* Set up a Chef workstation (was my local machine), again you can get
  instructions [from here](http://www.getchef.com/chef/install/). For OSX I
  used:

```
curl -L https://www.opscode.com/chef/install.sh | sudo bash
# clone the base chef repo somewhere
git clone git://github.com/opscode/chef-repo.git ~/chef-hubot
```

* On your workstation, setup cert/permission from the Chef master server:

```
cd ~/chef-hubot
mkdir -p .chef
scp root@chef-master:/etc/chef-server/admin.pem  ./.chef/
scp root@chef-master:/etc/chef-server/chef-validator.pem  ./.chef/
knife configure --initial

# follow the questions, choosing defaults, configuring paths for these pem files
# test the user was created OK with this knife command

knife user list
```

* This creates a new admin user on the master server you can login at
  https://chef-master:443

* From the workstation, install Chef on the hubot child node with this simple
  one liner (the hubot child node is a blank slate prior to this):

    `knife bootstrap hubot-hostname -x root`

* On your workstation copy the hubot cookbook from `./deployment/chef/hubot` to
  `./.chef/cookbooks/hubot`

* Edit `./.chef/cookbooks/hubot/attributes/default.rb` and set hubot options.

* Upload the cookbook and supporting files to the master server

    `knife cookbook upload -a`

* Add the cookbook to the hubot server run list

    `knife node run_list add hubot-hostname 'hubot'`

* Now you can wait 30 mins (or so) for the run list to be applied to the hubot
  server, _OR_ force it to run right now, by running this on the hubot child:

    `chef-client`

* Chef should install, configure and start hubot.

* After all that, take a break and have a cup of tea!

#### Helpful links

* Chef [Quick Overview](http://docs.opscode.com/chef_quick_overview.html)
