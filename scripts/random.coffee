# Description:
#   Ein paar weitere kleine Antworten von matthias
#
# Dependencies:
#   ../util
#
# Commands:
#   hubot bash me - Zufälliger Bash Link
#   hubot random <min> <max> - Zufallszahl zwischen <min> und <max> (nutzt random.org)
#
# Author:
#   kiliankoe

util = require "../util"

module.exports = (robot) ->
  robot.hear /matthias ist (.*)/i, (res) ->
    adj = res.match[1].toLowerCase()
    util.react res, "middle_finger"
    res.reply "Deine Mudda ist #{adj}!"

  robot.hear /matthias,? du bist (.*)/i, (res) ->
    adj = res.match[1].toLowerCase()
    util.react res, "middle_finger"
    res.reply "Deine Mudda ist #{adj}!"

  robot.hear /matthias scheißt auf (.*)/i, (res) ->
    term = res.match[1]
    util.react res, "middle_finger"
    res.reply "Deine Mudda scheißt auf #{term}!"

  robot.hear /bash me/i, (res) ->
    res.send "http://bash.fsrleaks.de/?#{randomRange(1, 946)}"

  robot.respond /random (\d*) (\d*)/i, (res) ->
    min = res.match[1]
    max = res.match[2]
    robot.http("https://www.random.org/integers/?num=1&min=#{min}&max=#{max}&format=plain&col=1&base=10")
      .get() (err, resp, body) ->
        res.send(body.trim())

randomRange = (min, max) ->
  Math.floor(Math.random() * (max - min) + min)
