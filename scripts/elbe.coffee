# Description:
#   Aktueller Elbpegel der Station Dresden
#
# Commands:
#   hubot elbe - Aktueller Elbpegel der Station Dresden
#
# Author:
#   dirkonet


module.exports = (robot) ->
  robot.respond /elbe/i, (msg) ->
    checkPegel(robot, msg)

checkPegel = (robot, msg) ->
  robot.http('http://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/DRESDEN/W/measurements.json?start=P0DT0H15M')
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      data = JSON.parse body
      ts = new Date(data[0].timestamp)
      date = "#{fuckinjsdatetime(ts.getDate())}.#{fuckinjsdatetime(ts.getMonth())}.#{ts.getFullYear()} #{fuckinjsdatetime(ts.getHours())}:#{fuckinjsdatetime(ts.getMinutes())} Uhr"
      msg.send "Aktueller Elbpegel, Stand #{date}: #{data[0].value}cm\nhttp://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/DRESDEN/W/measurements.png?start=P7D&width=900&height=400"

fuckinjsdatetime = (fuckinvalue) ->
  fuckinvalue = "#{fuckinvalue}"
  if fuckinvalue.length < 2
    return "0" + fuckinvalue
  return fuckinvalue
