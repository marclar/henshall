### Deploying with [Babushka](http://babushka.me)

* On the hubot server install the latest (stable) babushka with;

```
  sh -c "`curl https://babushka.me/up`"
  # answer the prompts, or if you prefer to
  # auto-install with no questions asked use;
  sh -c "`curl https://babushka.me/up`" </dev/null
```

* Copy the hubot deps from this repo to ~/.babushka/deps on the hubot server

    `scp -r ./deployment/babushka/deps hubot-hostname:~/.babushka/deps`

* Setup and launch hubot with babushka (on the hubot server) with;

    `babushka hubot`
