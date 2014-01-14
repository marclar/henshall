### Deploying with Ansible

* Install [ansible](http://docs.ansible.com/index.html), locally or on an ansible
  master server

* On master (or locally) edit `/etc/ansible/hosts` and add the hubot hostname/ip e.g.

```
[hubot]
129.21.11.111
```

* Ensure your public key is available on the hubot machine for passwordless SSH access
  (from local or master ansible server). Otherwise use --ask-pass flag with the
  playbook command below.

* Edit bot configuration in `hubot.yml`, then run the following (locally or from
  the ansible master)

    `ansible-playbook hubot.yml`
