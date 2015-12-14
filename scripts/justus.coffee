# Description:
#   bot-justus
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   niemand!

module.exports = (robot) ->
	robot.hear /\\justus (.+)/i, (msg) ->

		data = JSON.stringify({
		    text: '_' + msg.match[1] + '_'
		})

		robot.http('https://hooks.slack.com/services/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')
			.post(data) (err, res, body) ->
