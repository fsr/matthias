# Description:
#   Was gibt's heute zu essen?
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot mensa - Frag' hubot was es heute in der Alten Mensa gibt.
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /mensa/i, (msg) ->
    robot.http("http://openmensa.org/api/v2/canteens/79/days/today/meals")
      .get() (err, res, body) ->
        data = JSON.parse body
        msg.send "In der Alten Mensa gibt's heute:\n#{data.map(formatOutput).join('\n')}"

formatOutput = (meal) ->
  if meal.category == "Pasta"
    "Pasta mit #{meal.name}"
  else
    "#{meal.name} - #{meal.prices.students}€"
