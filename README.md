# 🤖 matjes

[![Travis](https://img.shields.io/travis/kiliankoe/matjes.svg?style=flat-square)](https://travis-ci.org/kiliankoe/matjes)

matjes is a chat bot (currently) built on top of the fantastic [hubot](https://hubot.github.com) framework. He's a fork of the beloved [Matthias](https://github.com/fsr/matthias), albeit a bit slimmed down and not connected to Slack but to Telegram. You can chat with him [@matjes_bot](https://t.me/matjes_bot).

### Running Matjes locally

You can start matjes locally by running:

    $ bin/hubot

Don't forget running `$ npm install` beforehand to download all necessary dependencies.

Then you can interact with matjes by typing `matjes help`.

    matjes> matjes help
    matjes animate me <query> - The same thing as `image me`, except adds [snip]
    matjes help - Displays all of the help commands that matjes knows about.
    ...

Matjes' name can also be substituted with a `!` at the beginning of commands. If you're messaging matjes directly, use just the command without a name prefix, e.g. `help`.
