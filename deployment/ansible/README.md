### Deploying with [Ansible](http://www.ansible.com/)

* Install Ansible, locally or on an Ansible master server following [these instructions](http://docs.ansible.com/intro_installation.html)

* On master (or locally) edit `/etc/ansible/hosts` and add the hubot hostname and ip address like so;

```
[hubot]
129.21.11.111
```

* Ensure your public key is available on the hubot machine for passwordless SSH access
  (from the local or master ansible server). Otherwise use --ask-pass flag with the
  playbook command below.

* Edit the hubot configuration in `deployment/ansible/hubot.yml`, then run the playbook command (locally or from
  the ansible master);

    `ansible-playbook hubot.yml`
