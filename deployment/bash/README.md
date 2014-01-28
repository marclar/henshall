### Deploying with [Bash](http://en.wikipedia.org/wiki/Bash_(Unix_shell))

* Edit `./deployment/bash/hubot.sh` and set variables to configure the bot

* Copy the bash script to the remote server and run it:

```
scp ./deployment/bash/hubot.sh hubot-hostname:~/
# then on remote server run
chmod 755 ~/hubot.sh && ~/hubot.sh
```

* The dependencies will install and the hubot service should start running
