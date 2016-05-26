# Description:
#   Decode QR codes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot qr <qr_url> - Dekodiere einen QR Code
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /qr (.*)/i, (msg) ->
    url = encodeURIComponent(msg.match[1])
    robot.http("https://api.qrserver.com/v1/read-qr-code/?fileurl=#{url}")
      .get() (err, res, body) ->
        unless err
          json = JSON.parse body
          msg.send(json[0]["symbol"][0]["data"])
        else
          msg.send("DOES NOT COMPUTE")
