# Description:
#   Was gibt's heute zu essen?
#
# Dependencies:
#   cron
#
# Configuration:
#   HUBOT_DEFAULT_MENSA, defaults to "Alte Mensa"
#
# Commands:
#   hubot mensa - Was gibt's heute in der Alten Mensa?
#   hubot mensa <mensa> - Was gibt's heute in <mensa>?
#   hubot mensen - Welche Mensen hubot kennt
#   hubot mensa bild <nr> - Bild zu bestimmter Mahlzeit finden
#
# Author:
#   kiliankoe - me@kilian.io
#   Justus Adam - me@justus.science
#   Philipp Heisig - matthias@pheisig.de
#   Lucas Woltmann - mail@lucaswoltmann.de

cronjob = require("cron").CronJob

default_mensa = process.env.HUBOT_DEFAULT_MENSA or "Alte Mensa"

mensen = [
    names: ["zelt", "zeltmensa", "neue", "neue mensa"]
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
    names: ["siedepunkt", "siede", "drehpunct", "drehpunkt"]
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
    names: ["stimm-gabel", "stimmgabel", "hfbk"]
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
      map.set(name, mensa.id)
    map
  , new Map())

module.exports = (robot) ->

  new cronjob('00 30 10 * * 1-5', ->
    dailyMensa()
  , null, true, "Europe/Berlin")

  dailyMensa = ->
    getMealData(mappedMensa.get(default_mensa.toLowerCase()), (data) ->
      if data != null and not (Array.isArray(data) and data.length == 0)
        robot.messageRoom "#mensa", formatMenuMessage(default_mensa, data)
    )

  generic_resp_func = (mensa, callback) ->
    mensaKey = mensa.toLowerCase()
    if mappedMensa.has mensaKey
      getMeals(mensa, mappedMensa.get(mensaKey), callback)
    else
      callback "Kenne leider keine solche Mensa..."

  getImage = (msg, imgid) ->
    tzoffset = (new Date()).getTimezoneOffset() * 60000
    now = (new Date(Date.now() - tzoffset)).toISOString().slice(0,10)
    robot.http("http://openmensa.org/api/v2/canteens/79/days/#{now}/meals")
      .get() (err, res, body) ->
        if body.trim() == ""
          msg.send "This mensa is currently out of order, sorry."
          return

        data = JSON.parse body
        output = "#{data.map(formatOutput).join('\n')}\n"
        stringstart = output.indexOf("#{imgid}: ")

        if stringstart == -1
          msg.send "No food with this number.."
          return

        stringstart += if imgid > 9 then 5 else 4
        output = output.substr(stringstart, output.indexOf("\n", stringstart) - stringstart)

        if output.indexOf("€") > -1
          output = output.substr(0, output.indexOf(" - "), output.length - 10)

        robot.http("http://www.studentenwerk-dresden.de/mensen/speiseplan/")
          .get() (err, res, body) ->
            if body.trim() == ""
              msg.send "No image found, sorry."
              return

            # would this substring madness not be a good place to use regex?
            body = body.substr(body.indexOf("<th class=\"text\">Alte Mensa</th>"))

            if body.indexOf(output) == -1
              msg.send "No image found, sorry."
              return

            body = body.substr(0, body.indexOf(output) + output.length + 4)
            body = body.substr(body.lastIndexOf("<a href") + 9)
            body = body.substr(0, body.indexOf("\">"))
            link = "http://www.studentenwerk-dresden.de/mensen/speiseplan/#{body}"
            robot.http(link)
              .get() (err, res, body) ->
                if body.trim() == ""
                  msg.send "No image found, sorry."
                  return

                imagelink = body.substr(body.indexOf("//bilderspeiseplan"))
                imagelink = imagelink.substr(0, imagelink.indexOf("\""))
                imagelink = "http:" + imagelink
                if imagelink.length < 20
                  msg.send ("No image found, sorry.")
                else
                  msg.send(imagelink)


  getMeals = (name, mensa, callback) ->
    getMealData(mensa, (data) -> callback(formatMenuMessage(name, data)))
  
  getMealData = (mensa, callback) ->
    tzoffset = (new Date()).getTimezoneOffset() * 60000
    now = (new Date(Date.now() - tzoffset)).toISOString().slice(0,10)
    robot.http("http://openmensa.org/api/v2/canteens/#{mensa}/days/#{now}/meals")
      .get() (err, res, body) ->
        callback (
          if body.trim() == ""
            null
          else
            JSON.parse body
        )

  robot.respond /mensa$/i, (msg) ->
    generic_resp_func(default_mensa, (m) -> msg.send m)

  robot.respond /mensatest/, (msg) ->
    dailyMensa()

  robot.respond /mensa (\S.*)/i, (msg) ->
    mensa = msg.match[1]
    if mensa.indexOf("bild") > -1
      return
    generic_resp_func(mensa, (m) -> msg.send m)

  robot.respond /mensa bild (\d*)/i, (msg) ->
    imgid = msg.match[1]
    getImage(msg, imgid)

  robot.respond /mensen/i, (msg) ->
    names = mensen.map((mensa) ->
      if mensa.names.length > 0
        mensa.names[0]
      else
        null
    ).filter((name) -> name != null)

    msg.send "Ich kann dir heutige Speisepläne für die folgenden Mensen holen:\n - #{names.join('\n - ')}\nSprich' mich einfach mit `matthias mensa <mensa>` an."

formatMenuMessage = (name, data) ->
  if data == null
    "This mensa is currently out of order, sorry."
  else
    "Heute @ *#{name}*:\n#{data.map(formatOutput).join('\n')}"

formatOutput = (meal, index) ->
  "#{index}: " +
    (if meal.category == "Pasta"
      "Pasta mit #{meal.name} #{formatMealNotes(meal.notes)}"
    else if meal.prices.students?
      "#{meal.name} - #{meal.prices.students.toFixed(2)}€ #{formatMealNotes(meal.notes)}#{formatMealCategory(meal.category)}"
    else
      "#{meal.name} #{formatMealNotes(meal.notes)}#{formatMealCategory(meal.category)}")

notesabbr = new Map(
    [ ["Rindfleisch", ":cow:"]
    , ["Schweinefleisch", ":pig:"]
    , ["vegetarisch", ":tomato:"]
    , ["vegan", ":herb:"]
    , ["Alkohol", ":wine_glass:"]
    , ["Knoblauch", ":garlic:"]
    ]
)

catabbr = new Map(
    [ ["Abendangebot", ":moon:"]
    , ["Angebote", ""]
    ]
)

formatMealNotes = (notes) ->
  notes.map((note) ->
      words = note.split(' ')
      words[words.length - 1]
    ).reduce((list, note) ->
      if notesabbr.has note
        list.push(notesabbr.get(note))
      list
  , []).join('')

formatMealCategory = (category) ->
  if catabbr.has category
    catabbr.get category
  else
    ""
