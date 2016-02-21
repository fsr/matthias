# Description:
#   version
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot version - Welche Version von hubot läuft gerade?
#
# Author:
#   kiliankoe

git = require 'git-rev'

module.exports = (robot) ->
    robot.respond /version/i, (msg) ->
        git.short (str) ->
            msg.send("Ich bin Matthias @ https://github.com/fsr/matthias/commit/#{str}")
