# Description:
#   Aktueller Elbpegel der Station Dresden
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot elbpegel - gibt den aktuellen Elbpegel der Station Dresden aus
#
# Author:
#   dirkonet


module.exports = (robot) ->
  robot.respond /elbpegel|elbe/i, (msg) ->
    checkPegel(robot, msg)

checkPegel = (robot, msg) ->
robot.http('http://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/DRESDEN/W/measurements.json?start=P0DT0H15M')
  .header('Accept', 'application/json')
  .get() (err, res, body) ->
    data = JSON.parse body
    res.send "Aktueller Elbpegel, Stand #{data[0].timestamp}: #{data.value}"
        
