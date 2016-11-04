# Description:
#   Maintaining hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot uptime - Wie lange läuft hubot aktuell schon?
#
# Author:
#   kiliankoe

moment = require 'moment'
moment.locale 'de'

module.exports = (robot) ->
  robot.respond /uptime/i, (res) ->
    duration = moment.duration uptime()
    res.send "Laufe aktuell seit #{start_time.format("Do MMM HH:mm")} Uhr, also schon #{duration.humanize()}."

start_time = moment()
uptime = () ->
  now = moment()
  now.diff start_time
