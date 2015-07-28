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
#   hubot mensa <mensa> - Frag' hubot was es heute in einer spezifischen Mensa gibt.
#   hubot mensen - Lass' hubot die Liste der unterstützten Mensen auflisten.
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /mensa$/i, (msg) ->
    getMeals("Alte Mensa", 79, robot, msg)

  robot.respond /mensa (.*)/i, (msg) ->
    mensa = msg.match[1]
    index = mensen.indexOf(mensa.toLowerCase()) + 79
    if index == 78
      msg.send "Kenne leider keine solche Mensa..."
      return
    getMeals(mensa, index, robot, msg)

  robot.respond /mensen/i, (msg) ->
    msg.send "Ich kann dir heutige Speisepläne für die folgenden Mensen holen:\n - #{mensen.join('\n - ')}\nSprich' mich einfach mit `matthias mensa <mensa>` an."

getMeals = (name, mensa, robot, msg) ->
  robot.http("http://openmensa.org/api/v2/canteens/#{mensa}/days/today/meals")
    .get() (err, res, body) ->
      data = JSON.parse body
      msg.send "Heute @ *#{name}*:\n#{data.map(formatOutput).join('\n')}"

formatOutput = (meal) ->
  if meal.category == "Pasta"
    "Pasta mit #{meal.name}"
  else if meal.prices.students?
    "#{meal.name} - #{meal.prices.students}€"
  else
    "#{meal.name}"

mensen = [
  "zelt",
  "alte",
  "reichenbachstraße",
  "mensologie",
  "siedepunkt",
  "tharandt",
  "palucca",
  "wu",
  "stimm-gabel",
  "johannstadt",
  "u-boot",
  "zittau",
  "sport",
  "kreuzgymnasium"
]
