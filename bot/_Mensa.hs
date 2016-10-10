-- Description:
--   Was gibt's heute zu essen?

-- Dependencies:
--   None

-- Configuration:
--   HUBOT_DEFAULT_MENSA : default mensa to return for 'hubot mensa' command

-- Commands:
--   hubot mensa - Frag' hubot was es heute in der Alten Mensa gibt.
--   hubot mensa <mensa> - Frag' hubot was es heute in einer spezifischen Mensa gibt.
--   hubot mensen - Lass' hubot die Liste der unterstützten Mensen auflisten.
--   hubot mensa bild <nr> - Lass' hubot das Bild zum Essen finden.

-- Author:
--   kiliankoe - me@kilian.io
--   Justus Adam - me@justus.science
--   Philipp Heisig - matthias@pheisig.de
--   Lucas Woltmann - mail@lucaswoltmann.de

module Mensa where

-- cronjob = require("cron").CronJob

import Marvin.Prelude

default_mensa = fromMaybe "Alte Mensa" <$> lookupConfigVal "default"


mensen = 
    [ (["zelt", "zeltmensa"], 78)
    , (["alte", "alte mensa"], 79)
    , (["reichenbachstraße"], 80)
    , (["mensologie"], 81)
    , (["siedepunkt"], 82)
    , (["tharandt"], 83)
    , (["palucca"], 84)
    , (["wu", "wundtstraße"], 85)
    , (["stimm-gabel", "stimmgabel"], 86)
    , (["johannstadt"], 87)
    , (["u-boot", "uboot"], 88)
    , (["zittau"], 89)
    -- , currently out of order (["zittau 2", "zittau zwei", "zittau II"], 90)
    , (["sport"], 91)
    , (["kreuzgymnasium", "kreuz"], 92)
    ]


mappedMensa :: HashMap Text Int
mappedMensa = mapFromList $ mensen >>= \(names, id) -> zip names (repeat id)

script = defineScript "mensa" $ do
    dailyMensa <- extractAction $ do
        def <- default_mensa
        generic_resp_func def (messageRoom "#mensa")
    
    void $ liftIO $ execSchedule $ do
        addJob dailyMensa "00 30 10 * * 1-5"


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


    getMeals name mensa callback =
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

    respond (r [CaseInsensitive] "mensa$") $ do
        def <- default_mensa
        generic_resp_func default_mensa send

    respond (r [CaseInsensitive] "mensa (\S.*)") $ do
        match <- getMatch
        let mensa = match `indexEx`1
        if "bild" `isInfixOf` mensa
            then return ()
            else generic_resp_func mensa send

    respond  (r [CaseInsensitive] "mensa bild (\d*)") $ do
        (_:imgid:_) <- getMatch
        getImage imgid

    respond (r [CaseInsensitive] "mensen") $ do
        let names = catMaybes $ map (headMay . fst) mensen
        send $ "Ich kann dir heutige Speisepläne für die folgenden Mensen holen:\n - " ++ intercalate ", " names ++ "\nSprich' mich einfach mit `matthias mensa <mensa>` an."

generic_resp_func mensa send = do
    let mensaKey = toLower mensa
    case lookup mensaKey mappedMensa of
        Nothing -> send "Kenne leider keine solche Mensa..."
        Just m -> getMeals mensa m send

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
  -- @justus: Wanna throw some functional magic on this? :D
  -- Here you go
  notes.map((note) ->
      words = note.split(' ')
      words[words.length - 1]
    ).reduce((list, note) ->
      if notesabbr.has note
        # it would better with immutable operations ... but this should be more performant
        list.push(notesabbr.get(note))
      list
  , []).join('')

formatMealCategory = (category) ->
  if catabbr.has category
    catabbr.get category
  else
    ""
