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

DONT_SHOW = 1900


init_birthdays = ->
	bdays = {}
	try
		for name, dateString of JSON.parse fs.readFileSync('./data/bday.json')
			bdays[name] = moment(dateString)
	catch err
		console.log "Couldn't find bdaydata.json."
	bdays

# Please enter your birthday into bday.json.
# If you don't want to include the year, please use 1900 as a placeholder to
# allow for correct parsing. Thanks.
bdays = init_birthdays()


module.exports = (robot) ->

	# Run every morning at 9 to congratulate people :)
	new cronjob('00 00 9 * * *', ->
			congratulate(robot)
		, null, true, "Europe/Berlin")

	# TODO: Implement me
	robot.respond /(birthday|bday|geburtstag)\??/i, (msg) ->
		today = moment()
		vallist = for name, value of bdays
			date = value.clone().year(today.year())
			if date < today
				date.add(1, 'years')
			[name, date]

		nearest = vallist.reduce((prev, curr) ->
				if prev == null or prev[1] > curr[1]
					curr
				else
					prev
			, null)
		name = nearest[0]
		msg.send formatBirthdayInfo(name, bdays[name])


	robot.respond /(birthday|bday|geburtstag) (.+)/i, (msg) ->
		name = msg.match[2].toLowerCase()
		if name == 'list' or name == 'liste'
			# Looks like we're going for the list below...
			return
		bday = bdays[name]
		if bday
			msg.send formatBirthdayInfo(name, bday)
		else
			msg.send "Sorry, ich kenne keinen Geburtstag von #{name.capitalize()}."

	robot.respond /(birthday|bday|geburtstag) list(e?)/i, (msg) ->
		msg.send "Ich kenne folgende Geburtstage:"
		for key, value of bdays
			msg.send formatBirthdayInfo(key, value)

formatBirthdayInfo = (name, birthday) ->
	if birthday.year() == DONT_SHOW
		# If the year is the current year the person doesn't want it shown.
		"#{name.capitalize()} hat am #{birthday.format('Do MMMM')} Geburtstag."
	else
		"#{name.capitalize()} wurde am #{birthday.format('Do MMMM YYYY')} geboren. Das war #{birthday.fromNow()}."

congratulate = (robot) ->
	for name, birthday of bdays
		today = moment()
		if today.month() == birthday.month() and today.day() == birthday.day()
			robot.messageRoom '#general', ":tada: Alles Gute zum Geburtstag, #{name.capitalize()}! :tada:"

# Kinda hoped to find this in the stdlib.
String.prototype.capitalize = () ->
	this.charAt(0).toUpperCase() + this.slice(1)
