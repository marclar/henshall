### Deploying with Bash

* Edit hubot.sh, set variables to configure the bot, then on bot machine run;

    `wget -O - https://raw.github.com/matthutchinson/henshall/master/deployment/bash/hubot.sh | sh`

* Dependencies will install and bot starts running (logging to /var/log/hubot.log)

*Note*: this bash script has been tested with Ubuntu 12.10 (YMMV with other dists)
