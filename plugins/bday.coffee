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
#   Justus Adam <me@justus.science>

fs = require('fs')
cronjob = require("cron").CronJob
moment = require('moment')
moment.locale('de_DE')

DONT_SHOW = 1900


init_birthdays = ->
	bdays = new Map()
	try
		for name, dateString of JSON.parse fs.readFileSync('./data/bday.json')
			bdays.set(name, moment(dateString))
	catch err
		console.log "Couldn't find bday.json."
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

	robot.respond /(birthday|bday|geburtstag)\??$/i, (msg) ->
		today = moment()
		vallist = Array.from(bdays.entries()).map ([name, value]) ->
			date = value.clone().year(today.year())
			if date < today
				date.add(1, 'years')
			[name, date]

		[name, date] = vallist.reduce (prev, curr) ->
				if prev == null or prev[1] > curr[1]
					curr
				else
					prev
			, null

		birthdayBoysAndGirls = vallist.filter((elem) ->
			elem[1].days() == date.days() and elem[1].month() == date.month()
		).map((elem) -> elem[0].capitalize())

		daysDiff = date.diff(today, 'days')
		last = birthdayBoysAndGirls.length - 1

		diffStr =
			if daysDiff == 0 then "heute!"
			else "in nur #{daysDiff} Tagen."

		msgStr =
			if birthdayBoysAndGirls.length < 2
				"Das nächste Geburtstagskind ist #{birthdayBoysAndGirls[0]}"
			else "Die nächsten Geburstage sind von " + birthdayBoysAndGirls.slice(0, last).join(", ") + ' und ' + birthdayBoysAndGirls[last]
		msg.send msgStr + " " + diffStr



	robot.respond /(birthday|bday|geburtstag) (.+)/i, (msg) ->
		name = msg.match[2].toLowerCase()
		if name == 'list' or name == 'liste'
			# Looks like we're going for the list below...
			return
		bday = bdays.get(name)
		if bday
			msg.send formatBirthdayInfo(name, bday)
		else
			msg.send "Sorry, ich kenne keinen Geburtstag von #{name.capitalize()}."

	robot.respond /(birthday|bday|geburtstag) list(e?)/i, (msg) ->
		msg.send "Ich kenne folgende Geburtstage:"
		bdays.forEach (value, key) ->
			msg.send formatBirthdayInfo(key, value)

formatBirthdayInfo = (name, birthday) ->
	if birthday.year() == DONT_SHOW
		"#{name.capitalize()} hat am #{birthday.format('Do MMMM')} Geburtstag."
	else
		age = moment().diff birthday, 'years'
		"#{name.capitalize()} wurde am #{birthday.format('Do MMMM YYYY')} geboren. Das war vor #{age} Jahren! :O"

congratulate = (robot) ->
	bdays.forEach (birthday, name) ->
		today = moment()
		if today.month() == birthday.month() and today.date() == birthday.date()
			robot.messageRoom '#random', ":tada: Alles Gute zum Geburtstag, #{name.capitalize()}! :tada:"

# Kinda hoped to find this in the stdlib.
String.prototype.capitalize = () ->
	this.charAt(0).toUpperCase() + this.slice(1)
