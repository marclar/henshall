### Deploying with [Babushka](http://babushka.me)

* On the hubot server itself install the latest (stable) Babushka with:

```
sh -c "`curl https://babushka.me/up`"
# answer the prompts, or if you prefer to
# auto-install with no questions asked use;
sh -c "`curl https://babushka.me/up`" </dev/null
```

* Copy the hubot deps to ~/.babushka/deps on the hubot server:

    `scp -r ./deployment/babushka/deps hubot-hostname:~/.babushka/deps`

* SSH to the hubot server and install the hubot dep with:

    `babushka hubot`

* This installs all the dependencies required for hubot to run, and starts the
  hubot service.

#### Helpful links

* [Installing Babushka](http://babushka.me/installing)
* [Babushka RDoc](http://rubydoc.info/github/benhoskings/babushka/master/frames)
* [Ben Hoskings Deps](https://github.com/benhoskings/babushka-deps)
