### Deploying with Babushka

Docs and more info on Babushka are available [here](http://babushka.me)

* On the hubot server install the latest stable babushka with;

    sh -c "`curl https://babushka.me/up`"
    # answer the prompts, or if you prefer to
    # auto-install with no questions asked use;
    sh -c "`curl https://babushka.me/up`" </dev/null

* Make an empty dep dir on hubot

    mkdir ~/.babushka/deps

* Copy the hubot.rb and hubot/ folder from this repo to ~/.babushka/deps on the
  hubot server

    scp -r ./deployment/babushka/hubot* hubot-server:~/.babushka/deps/

* Run babushka with hubot dep on the hubot server

    babushka hubot
