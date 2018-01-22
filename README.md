# 🤖 matthias

[![Docker Build Status](https://img.shields.io/docker/build/ifsr/matthias.svg?style=flat-square)](https://hub.docker.com/r/ifsr/matthias/)

Matthias is a chat bot (currently) built on top of the fantastic [hubot](https://hubot.github.com) framework. He should be online in our Slack team.

### Running matthias locally

Choose between running matthias directly or via docker.

**Warning:** Several of matthias' capabilities require a few env vars to be set. Please refer to `run.sh` for a list of them.

#### Using your dev environment

You can start matthias locally by running:

```shell
$ npm install
$ ./bin/hubot
```
Then you can interact with matthias by typing `matthias help`.

    matthias> matthias help
    matthias animate me <query> - The same thing as `image me`, except adds [snip]
    matthias help - Displays all of the help commands that matthias knows about.
    ...

Matthias' name can also be substituted with a `!` at the beginning of commands. If you're messaging matthias directly, use just the command without a name prefix, e.g. `help`

#### Using Docker

```shell
$ docker pull ifsr/matthias
$ docker run --rm -it matthias
```

This pulls matthias' latest image (automatically built by Docker Hub from this repo) and starts a new ephemeral container with the shell adapter. 
