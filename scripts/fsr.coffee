# Description:
#   FSR Krams
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot protokoll - Frag' hubot nach dem aktuellem protokoll
#   hubot protokoll <datum> - Frag' hubot nach dem Protokoll von <datum> (ISO-Format)
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /protokoll(.*)/i, (msg) ->
    date = msg.match[1]
    if date == ""
      msg.send "https://www.ifsr.de/protokolle/current.pdf"
    else
      year = date.split("-")[0]
      dateobj = new Date(date)
      if dateobj.getDay() != 1
        msg.send "Das war leider kein Sitzungsdatum."
      else
        msg.send "https://www.ifsr.de/protokolle/#{year.slice(1, year.length)}/#{date.slice(1, date.length)}.pdf"
