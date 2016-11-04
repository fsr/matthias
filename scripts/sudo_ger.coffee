# Description:
#   sudo
#
# Commands:
#   hubot sudo - Zwing hubot dazu, etwas zu tun
#
# Author:
#   kiliankoe

module.exports = (robot) ->
  robot.respond /sudo (.*)/i, (msg) ->
    befehl = msg.match[1]
    msg.send('Ok! Ich ' + befehl)
