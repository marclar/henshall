### Deploying with [Ansible](http://www.ansible.com/)

Ansible can be installed on your local machine or an remote Ansible master
server.

* Install Ansible by following [these
  instructions](http://docs.ansible.com/intro_installation.html).

* Edit `/etc/ansible/hosts` and add the hubot hostname and ip address like so:

```
[hubot-hostname]
129.21.11.111
```

* Ensure your public key is available on the hubot machine for passwordless SSH
  access (from the local or master ansible server). Otherwise use --ask-pass
  flag with the playbook command below.

* Edit the hubot configuration vars in `deployment/ansible/hubot.yml`

* Run the playbook command (locally or from the ansible master) with:

    `ansible-playbook ./deployment/ansible/hubot.yml`

### Helpful Links

* [Installing Ansible](http://docs.ansible.com/intro_installation.html)
* [Ansible Docs](http://docs.ansible.com)
* [Ansible GitHub](https://github.com/ansible)
