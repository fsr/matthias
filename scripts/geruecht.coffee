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
    robot.respond /geruecht|gerücht/i, (msg) ->
      user = process.env.FSRUSERNAME
      pw = process.env.FSRPASSWORD
      robot.http("http://#{user}:#{pw}@leaks.fsrleaks.de/index.php")
        .get() (err, res, body) ->
            $ = cheerio.load body
            geruecht = $('div').text().replace /Psst\.\.\./, ""
            geruecht = geruecht.trim()
            geruecht = msg.random(prefixes) + geruecht
            msg.send geruecht

prefixes = [
    "Also... Ich hab ja Folgendes gehört: "
    "Pssht... "
    "Ein kleines Vögelchen hat mir das hier verraten: "
    "Die BILD Zeitung soll ja das hier morgen als Titelstory haben: "
]
