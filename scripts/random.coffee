# Description:
#   Ein paar weitere kleine Antworten von matjes
#
# Dependencies:
#   ../util
#
# Commands:
#
# Author:
#   kiliankoe

util = require "../util"

module.exports = (robot) ->
  robot.respond /ist (.*)/i, (res) ->
    adj = res.match[1].toLowerCase()
    res.reply "Deine Mudda ist #{adj}! 🖕"

  robot.respond /,? du bist (.*)/i, (res) ->
    adj = res.match[1].toLowerCase()
    res.reply "Deine Mudda ist #{adj}! 🖕"

  robot.respond /scheißt auf (.*)/i, (res) ->
    term = res.match[1]
    res.reply "Deine Mudda scheißt auf #{term}! 🖕"
