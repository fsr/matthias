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
  robot.hear /matjes ist (.*)/i, (res) ->
    adj = res.match[1].toLowerCase()
    res.reply "Deine Mudda ist #{adj}! 🖕"

  robot.hear /matjes,? du bist (.*)/i, (res) ->
    adj = res.match[1].toLowerCase()
    res.reply "Deine Mudda ist #{adj}! 🖕"

  robot.hear /matjes scheißt auf (.*)/i, (res) ->
    term = res.match[1]
    res.reply "Deine Mudda scheißt auf #{term}! 🖕"
