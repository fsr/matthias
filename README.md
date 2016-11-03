# matthias

[![Travis](https://img.shields.io/travis/fsr/matthias.svg?style=flat-square)](https://travis-ci.org/fsr/matthias)

Matthias is a chat bot (currently) built on top of the fantastic [hubot](https://hubot.github.com) framework.

### Running matthias locally

You can start matthias locally by running:

    % bin/hubot

You'll see some start up output and a prompt:

    [Sat Feb 28 2015 12:38:27 GMT+0000 (GMT)] INFO Using default redis on localhost:6379
    matthias>

Then you can interact with matthias by typing `matthias help`.

    matthias> matthias help
    matthias animate me <query> - The same thing as `image me`, except adds [snip]
    matthias help - Displays all of the help commands that matthias knows about.
    ...

### Configuration

A few scripts (including some installed by default) require environment
variables to be set as a simple form of configuration.

Each script should have a commented header which contains a "Configuration"
section that explains which values it requires to be placed in which variable.
When you have lots of scripts installed this process can be quite labour
intensive. The following shell command can be used as a stop gap until an
easier way to do this has been implemented.

    grep -o 'hubot-[a-z0-9_-]\+' external-scripts.json | \
      xargs -n1 -I {} sh -c 'sed -n "/^# Configuration/,/^#$/ s/^/{} /p" \
          $(find node_modules/{}/ -name "*.coffee")' | \
        awk -F '#' '{ printf "%-25s %s\n", $1, $2 }'

How to set environment variables will be specific to your operating system.
Rather than recreate the various methods and best practices in achieving this,
it's suggested that you search for a dedicated guide focused on your OS.
