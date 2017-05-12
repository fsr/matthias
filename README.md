# 🤖 matthias

[![Travis](https://img.shields.io/travis/fsr/matthias.svg?style=flat-square)](https://travis-ci.org/fsr/matthias)

Matthias is a chat bot (currently) built on top of the fantastic [hubot](https://hubot.github.com) framework. He should be online in our Slack team.

### Running matthias locally

You can start matthias locally by running:

    $ bin/hubot
    
Don't forget `$ npm install` before your first run to download all necessary dependencies.

Then you can interact with matthias by typing `matthias help`.

    matthias> matthias help
    matthias animate me <query> - The same thing as `image me`, except adds [snip]
    matthias help - Displays all of the help commands that matthias knows about.
    ...
    
Matthias' name can also be substituted with a `!` at the beginning of commands. If you're messaging matthias directly, use just the command without a name prefix, e.g. `help`.
