# Description:
#   Maintaining hubot
#
# Dependencies:
#   moment
#
# Configuration:
#   HUBOT_MAINTAINERS = comma-separated list of usernames currently maintaining this hubot
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
    res.send "Laufe aktuell seit dem #{start_time.format("Do MMM HH:mm")} Uhr, also schon #{duration.humanize()}."

start_time = moment()
uptime = () ->
  now = moment()
  now.diff start_time

is_maintainer = (name) ->
  maintainers = process.env.HUBOT_MAINTAINERS or ""
  maintainers = maintainers.split ","
  maintainers.includes name.toLowerCase()
