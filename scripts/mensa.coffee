# Description:
#   Was gibt's heute zu essen?
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DEFAULT_MENSA : default mensa to return for 'hubot mensa' command
#
# Commands:
#   hubot mensa - Frag' hubot was es heute in der Alten Mensa gibt.
#   hubot mensa <mensa> - Frag' hubot was es heute in einer spezifischen Mensa gibt.
#   hubot mensen - Lass' hubot die Liste der unterstützten Mensen auflisten.
#
# Author:
#   kiliankoe - me@kilian.io
#   Justus Adam - me@justus.science


default_mensa = process.env.HUBOT_DEFAULT_MENSA or "Alte Mensa"


mensen = [
    names: ["zelt", "zeltmensa"]
    id: 78
  ,
    names: ["alte", "alte mensa"]
    id: 79
  ,
    names: ["reichenbachstraße"]
    id: 80
  ,
    names: ["mensologie"]
    id: 81
  ,
    names: ["siedepunkt"]
    id: 82
  ,
    names: ["tharandt"]
    id: 83
  ,
    names: ["palucca"]
    id: 84
  ,
    names: ["wu", "wundtstraße"]
    id: 85
  ,
    names: ["stimm-gabel", "stimmgabel"]
    id: 86
  ,
    names: ["johannstadt"]
    id: 87
  ,
    names: ["u-boot", "uboot"]
    id: 88
  ,
    names: ["zittau"]
    id: 89
  , # currently out of order
    names: ["zittau 2", "zittau zwei", "zittau II"]
    id: 90
  ,
    names: ["sport"]
    id: 91
  ,
    names: ["kreuzgymnasium", "kreuz"]
    id: 92
  ]


mappedMensa = mensen.reduce((map, mensa) ->
    mensa.names.forEach (name) ->
      map[name] = mensa.id
    map
  , {})


module.exports = (robot) ->

  generic_resp_func = (mensa, callback) ->
    mensaKey = mensa.toLowerCase()
    if not mappedMensa.hasOwnProperty mensaKey
      callback "Kenne leider keine solche Mensa..."
    else
      getMeals(mensa, mappedMensa[mensaKey], callback)

  getMeals = (name, mensa, callback) ->
    robot.http("http://openmensa.org/api/v2/canteens/#{mensa}/days/today/meals")
      .get() (err, res, body) ->
        callback (
          if body.trim() == ""
            "This mensa is currently out of order, sorry."
          else
            data = JSON.parse body
            "Heute @ *#{name}*:\n#{data.map(formatOutput).join('\n')}"
        )


  robot.respond /mensa$/i, (msg) ->
    generic_resp_func(default_mensa, (m) -> msg.send m)

  robot.respond /mensa (\S.*)/i, (msg) ->
    mensa = msg.match[1]
    generic_resp_func(mensa, (m) -> msg.send m)

  robot.respond /mensen/i, (msg) ->
    names = mensen.map((mensa) ->
      if mensa.names.length > 0
        mensa.names[0]
      else
        null
    ).filter((name) -> name != null)

    msg.send "Ich kann dir heutige Speisepläne für die folgenden Mensen holen:\n - #{names.join('\n - ')}\nSprich' mich einfach mit `matthias mensa <mensa>` an."


formatOutput = (meal) ->
  if meal.category == "Pasta"
    "Pasta mit #{meal.name}"
  else if meal.prices.students?
    "#{meal.name} - #{meal.prices.students}€"
  else
    "#{meal.name}"
