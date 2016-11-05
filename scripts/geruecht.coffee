# Description:
#   geruecht
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot gerücht - Lass' hubot aus dem Nähkästchen plaudern
#
# Author:
#   kiliankoe

cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.respond /ger(?:ü|ue)cht/i, (res) ->
    user = process.env.FSRUSERNAME
    pw = process.env.FSRPASSWORD
    robot.http("http://#{user}:#{pw}@leaks.fsrleaks.de/index.php")
      .get() (err, resp, body) ->
        $ = cheerio.load body
        geruecht = $('div').text().replace /Psst\.\.\./, ""
        if geruecht == ""
          res.send "leaks.fsrleaks.de scheint down zu sein, @sebastian?"
        else
          geruecht = geruecht.trim()
          geruecht = res.random(prefixes) + geruecht
          res.send geruecht

prefixes = [
  "Also... Ich hab ja Folgendes gehört: ",
  "Pssht... ",
  "Ein kleines Vögelchen hat mir das hier verraten: ",
  "Die BILD Zeitung soll ja das hier morgen als Titelstory haben: ",
  "Böse Zungen behaupten ja: ",
  "Bei Fefe stand letzte Woche: ",
  "Also bei Sebi in der BRAVO Girl stand ja letztens: "
]
