### Deploying with [Bash](http://en.wikipedia.org/wiki/Bash_(Unix_shell))

Edit `./deployment/bash/hubot.sh` and set variables to configure the bot

Copy the bash script to the remote server and run it:

    scp ./deployment/bash/hubot.sh hubot-hostname:~/
    # then to run on the remote server
    ssh hubot-hostname 'chmod 755 ~/hubot.sh && ~/hubot.sh'
    # script output will log to your terminal

The dependencies will install and the hubot service should start running
