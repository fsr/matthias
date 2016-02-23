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
#   hubot mensa bild <nr> - Lass' hubot das Bild zum Essen finden.
#
# Author:
#   kiliankoe - me@kilian.io
#   Justus Adam - me@justus.science
#   Philipp Heisig - matthias@pheisig.de
#   Lucas Woltmann - mail@lucaswoltmann.de

cronjob = require("cron").CronJob

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

  new cronjob('00 30 10 * * 1-5', ->
    dailyMensa(robot)
  , null, true, "Europe/Berlin")

  dailyMensa = (robot) ->
    generic_resp_func(default_mensa, (m) -> robot.messageRoom '#mensa', m)

  generic_resp_func = (mensa, callback) ->
    mensaKey = mensa.toLowerCase()
    if not mappedMensa.hasOwnProperty mensaKey
      callback "Kenne leider keine solche Mensa..."
    else
      getMeals(mensa, mappedMensa[mensaKey], callback)

  getImage = (msg, imgid) ->
    tzoffset = (new Date()).getTimezoneOffset() * 60000
    now = (new Date(Date.now() - tzoffset)).toISOString().slice(0,10)
    robot.http("http://openmensa.org/api/v2/canteens/79/days/#{now}/meals")
      .get() (err, res, body) ->
        if body.trim() == ""
          msg.send "This mensa is currently out of order, sorry."
        else
          data = JSON.parse body
          output = "#{data.map(formatOutput).join('\n')}\n"
          stringstart = output.indexOf("#{imgid}: ")
          if stringstart > -1
            if imgid > 9
              stringstart += 5
            else
              stringstart += 4
            output = output.substr(stringstart, output.indexOf("\n", stringstart) - stringstart)
            if output.indexOf("€") > -1
              output = output.substr(0, output.indexOf(" - "), output.length - 10)
            robot.http("http://www.studentenwerk-dresden.de/mensen/speiseplan/")
              .get() (err, res, body) ->
                if body.trim() == ""
                  msg.send ("No image found, sorry.")
                else
                  body = body.substr(body.indexOf("<th class=\"text\">Alte Mensa</th>"))
                  if body.indexOf(output) > -1
                    body = body.substr(0, body.indexOf(output) + output.length + 4)
                    body = body.substr(body.lastIndexOf("<a href") + 9)
                    body = body.substr(0, body.indexOf("\">"))
                    link = "http://www.studentenwerk-dresden.de/mensen/speiseplan/" + body
                    robot.http(link)
                      .get() (err, res, body) ->
                        if body.trim() == ""
                          msg.send ("No image found, sorry.")
                        else
                          imagelink = body.substr(body.indexOf("//bilderspeiseplan"))
                          imagelink = imagelink.substr(0, imagelink.indexOf("\""))
                          imagelink = "http:" + imagelink
                          if imagelink.length < 20
                            msg.send ("No image found, sorry.")
                          else
                            msg.send(imagelink)
                  else
                    msg.send ("No image found, sorry.")
          else
            msg.send("No food with this number..");


  getMeals = (name, mensa, callback) ->
    tzoffset = (new Date()).getTimezoneOffset() * 60000
    now = (new Date(Date.now() - tzoffset)).toISOString().slice(0,10)
    robot.http("http://openmensa.org/api/v2/canteens/#{mensa}/days/#{now}/meals")
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

formatOutput = (meal, index) ->
  "#{index}: " +
    (if meal.category == "Pasta"
      "Pasta mit #{meal.name} #{formatMealNotes(meal.notes)}"
    else if meal.prices.students?
      "#{meal.name} - #{meal.prices.students.toFixed(2)}€ #{formatMealNotes(meal.notes)}#{formatMealCategory(meal.category)}"
    else
      "#{meal.name} #{formatMealNotes(meal.notes)}#{formatMealCategory(meal.category)}")

notesabbr =
  Rindfleisch: ":cow:"
  Schweinefleisch: ":pig:"
  vegetarisch: ":tomato:"
  vegan: ":herb:"
  Alkohol: ":wine_glass:"
  Knoblauch: ":garlic:"

catabbr =
  Abendangebot: ":moon:"
  Angebote: ""

formatMealNotes = (notes) ->
  # @justus: Wanna throw some functional magic on this? :D
  # Here you go
  notes.map((note) ->
      words = note.split(' ')
      words[words.length - 1]
    ).reduce((list, note) ->
      if notesabbr.hasOwnProperty note
        # it would better with immutable operations ... but this should be more performant
        list.push(notesabbr[note])
      list
  , []).join('')

formatMealCategory = (category) ->
  if catabbr.hasOwnProperty category
    catabbr[category]
  else
    ""
