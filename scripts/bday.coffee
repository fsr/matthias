# Description:
#   Happy Birthday \o/
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot birthday? - Who's is the next upcoming birthday?
#   hubot birthday <name> - When's <name>'s birthday?
#   hubot birthday list - List all known birthdays.
#
# Author:
#   kiliankoe

fs = require('fs')
cronjob = require("cron").CronJob
moment = require('moment')
moment.locale('de_DE')

# Please enter your birthday into bdaydata.json.
# If you don't want to include the year, please use 1900 as a placeholder to
# allow for correct parsing. Thanks.
bdays = {}

fs.readFile './scripts/bdaydata.json', (err, data) ->
	if err
		console.log "Couldn't find bdaydata.json."
	bdays = JSON.parse data
	# Let's just go ahead and replace all 1900's with the current year.
	Object.keys(bdays).forEach (name) ->
		dateString = bdays[name]
		currentYear = new Date().getFullYear()
		bdays[name] = dateString.replace("1900", currentYear)


module.exports = (robot) ->

	# Run every morning at 9 to congratulate people :)
	new cronjob('00 00 9 * * *', ->
      congratulate(robot)
    , null, true, "Europe/Berlin")

	# TODO: Implement me
	# robot.respond /(birthday|bday|geburtstag)\?/i, (msg) ->

	robot.respond /(birthday|bday|geburtstag) (.+)/i, (msg) ->
		name = msg.match[2]
		if name == 'list' or name == 'liste'
			# Looks like we're going for the list below...
			return
		if bdays[name.toLowerCase()]
			msg.send formatBirthdayInfo(name)
		else
			msg.send "Sorry, ich kenne keinen Geburtstag von #{name.capitalize()}."

	robot.respond /(birthday|bday|geburtstag) list(e?)/i, (msg) ->
		msg.send "Ich kenne folgende Geburtstage:"
		Object.keys(bdays).forEach (name) ->
			msg.send formatBirthdayInfo(name)

formatBirthdayInfo = (name) ->
	birthday = moment(bdays[name.toLowerCase()])
	if birthday.year() == moment().year()
		# If the year is the current year the person doesn't want it shown.
		"#{name.capitalize()} hat am #{birthday.format('Do MMMM')} Geburtstag."
	else
		"#{name.capitalize()} wurde am #{birthday.format('Do MMMM YYYY')} geboren. Das war #{birthday.fromNow()}."

congratulate = (robot) ->
	Object.keys(bdays).forEach (name) ->
		birthday = moment(bdays[name.toLowerCase()])
		today = moment()
		if today.month() == birthday.month() and today.day() == birthday.day()
			robot.messageRoom '#general', ":tada: Alles Gute zum Geburtstag, #{name.capitalize()}! :tada:"

# Kinda hoped to find this in the stdlib.
String.prototype.capitalize = () ->
    this.charAt(0).toUpperCase() + this.slice(1)
