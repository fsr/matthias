# Description:
#   Ein paar weitere kleine Antworten von matthias
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot bash me - Frag' hubot nach einem random Zitat link
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /bash me/i, (msg) ->
    msg.send "http://bash.fsrleaks.de/?#{randomRange(1, 631)}"

randomRange = (min, max) ->
  Math.floor(Math.random() * (max - min) + min)
