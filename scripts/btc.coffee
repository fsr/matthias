# Description:
#   BTC Krams
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot btc - Frag' hubot nach dem aktuellem BTC Kurs
#
# Author:
#   kiliankoe

module.exports = (robot) ->
	robot.respond /btc/i, (msg) ->
		robot.http('https://api.coinbase.com/v2/exchange-rates?currency=BTC')
			.get() (err, res, body) ->
				data = JSON.parse body
				USD = data["data"]["rates"]["USD"]
				EUR = data["data"]["rates"]["EUR"]
				msg.send("Aktueller BTC Kurs: " + USD + "$ oder " + EUR + "€")