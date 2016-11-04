# Description:
#   version
#
# Dependencies:
#   git-rev
#
# Commands:
#   hubot version - Welche Version von hubot läuft gerade?
#
# Author:
#   kiliankoe

git = require 'git-rev'

module.exports = (robot) ->
  robot.respond /version/i, (msg) ->
    git.short (hash) ->
      msg.send hash
