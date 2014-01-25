### Deploying with Chef

### Notes

* The master server requires 1GB RAM - anything lower and the install will fail :(
* Chef master, workstation and children must all be able to access each other
  from real resolvable host names
* This [quick overview](http://docs.opscode.com/chef_quick_overview.html) is useful for a quick
  overview of Chef

### Getting Started

* Install chef master server, get the package to install [from here](http://www.getchef.com/chef/install/)

    wget
    https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.10-1.ubuntu.12.04_amd64.deb
    dpkg -i  chef-server_11.0.10-1.ubuntu.12.04_amd64.deb
    chef-server-ctl reconfigure

* Set up a chef workstation (could be your local machine), again you can get
  instructions [from here](http://www.getchef.com/chef/install/), For OSX I used;

    # install the workstation client
    curl -L https://www.opscode.com/chef/install.sh | sudo bash
    # clone the base chef repo somewhere
    git clone git://github.com/opscode/chef-repo.git ~/chef-hubot

* On the workstation, setup configuration/permissions from chef master server

    cd ~/chef-hubot
    mkdir -p .chef
    scp root@chef-master:/etc/chef-server/admin.pem  ./.chef/
    scp root@chef-master:/etc/chef-server/chef-validator.pem  ./.chef/
    knife configure --initial
    # follow the questions, choosing defaults, configure paths for pem files
    # test the user was created OK with
    knife user list

* After this a new admin user will be created on the master server you can login at https://chef-master:443

* From the workstation, install chef on the hubot child node with this simple one liner

    knife bootstrap hubot-hostname -x root

* Copy the hubot cookbook from this repo to ./.chef/cookbooks

* Upload the cookbook and supporting files to the master server

    knife cookbook upload -a

* Add the cookbook to the hubot server run list

    knife node run_list add hubot-hostname 'hubot'

* Wait 30 mins or so for the run list to be applied to the hubot server from the
  master, OR force it to run right now, by ssh-ing to the hubot client server
  and running

    chef-client

* Take a break and have a cup of tea
