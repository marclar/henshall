### Deploying with [Ansible](http://www.ansible.com/)

Ansible can be installed on your local machine or a remote Ansible master
node.

Install Ansible by following [these
instructions](http://docs.ansible.com/intro_installation.html).

Edit `/etc/ansible/hosts` and add the hubot host and ip address like so:

    [hubot-hostname]
    129.21.11.111

This ensures the master node knows about the hubot child node.

Next, copy the deployment/ansible directory from this repo to the master node.

    scp -r ./deployment/ansible/* ansible-master:~/

Edit the hubot configuration vars in `~/hubot.yml`

Next ensure your SSH key is configured on the hubot child node for passwordless
SSH access from the master node. Otherwise use --ask-pass flag with the playbook
command below.

Run the playbook command (locally or from the ansible master) with:

    ansible-playbook ~/hubot.yml

#### Helpful links

* [Installing Ansible](http://docs.ansible.com/intro_installation.html)
* [Ansible Docs](http://docs.ansible.com)
* [Ansible Module Index](http://docs.ansible.com/modules_by_category.html)
