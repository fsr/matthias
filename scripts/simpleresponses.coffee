# Description:
#   Einfache trigger-response Interaktionen
#
# Dependencies:
#   ../util
#
# Commands:
#   hubot pizza - hubot nennt alle Details für eine Pizzabestellung (im Ratsaal)
#   hubot filmlist - Frag' hubot nach Links zu beiden Filmlisten
#
# Author:
#   kiliankoe

util = require "../util"

responses = [
  [
    /pizza/i,
    "Ich bin Matthias Stuhlbein, Nöthnitzer Str. 46, 01187 Dresden. Fakultät Informatik. Mail: pizza@ifsr.de, Telefon: 0351 46338223 - Pizzen schneiden nicht vergessen ;)"
  ],
  [
    /filmlist/i,
    "Vorschläge: http://letterboxd.com/kiliankoe/list/ifsr-filmvorschlage/\nGeschaute Filme: http://letterboxd.com/kiliankoe/list/ifsr-movie-night/"
  ],
  [
    /wat is wacken\?/i,
    "Dat ist Wacken. Einmal im Jahr kommen hier alle bösen schwarzen Männer aus Mittelerde her, um ma richtig die Sau rauszulassen."
  ],
  [
    /marco/i,
    "POLO"
  ]
]

listens = [
  [/pimmel/i, "Höhöhö, du hast Pimmel gesagt."],
  [/anyway/i, "how's your sex life?"],
  [/jehova/i, "http://i.imgur.com/01PMBGj.gif"],
  [/you're tearing me apart|the room|tommy wiseau/,  "http://i.giphy.com/pTrgmCL2Iabg4.gif"],
  [/citrix|35000|35\.000|35k/, ":moneybag::moneybag::moneybag:"],
  [/^nein$/i, "Doch!"],
  [/gewitter/i, "Gewitter? In Neuss?"]
]

rarelistens = [
  [/\sphp|^php/, "Naja, ich hab mit PHP auch schon richtig gut funktioni⍰\nParse error: syntax error, unexpected '::' (T_PAAMAYIM_NEKUDOTAYIM) in Command line code on line 1"],
  [/spiel|game/i, "ICH HAB' DAS SPIEL VERLOREN!"]
]

reactions = [
  [/ascii/, ["ascii"]],
  [/bayern/, ["logik", "bavaria"]],
  [/brandenburg/, ["tumbleweed"]],
  [/brandschutz/, ["brandschutz"]],
  [/bravo girl/, ["bravo"]],
  [/cage/, ["onetruegod"]],
  [/datenbank/, ["sascha"]],
  [/\bduck\b/i, ["mind-the-quack"]],
  [/einöde/, ["brandenburg"]],
  [/\bente\b/i, ["mind-the-quack"]],
  [/fancy/, ["weber_sunglasses"]],
  [/fefe/, ["fefe"]],
  [/gabba/, ["gandalf"]],
  [/graz/, ["graz"]],
  [/haskell/, ["justus"]],
  [/kapital/, ["marx"]],
  [/lobo/, ["lobo"]],
  [/lecker/, ["letscho"]],
  [/monty python/, ["sillywalk"]],
  [/muss man wissen/, ["stoll"]],
  [/pampa/, ["brandenburg"]],
  [/\sphp|^php/, ["php", "amen", "praisebe"]],
  [/\bruhe\b/, ["psst"]],
  [/rust/, ["feliix"]],
  [/star wars/, ["leia"]],
  [/stiefel/, ["stiefel"]],
  [/stoll/, ["stoll"]],
  [/swift/, ["kilian2"]],
  [/thüringen/, ["thueringen"]],
  [/weed/, ["gandalf"]],
  [/zaunpfahl/, ["zaunpfahl"]],
  [/zu alt/, ["old_man_yells_at_cloud"]]
]

topic_adjectives = [
  "dämliches",
  "doofes",
  "komisches",
  "eigenartiges",
  "'interessantes'",
  "dummes",
  "kack"
]

module.exports = (robot) ->
  responses.forEach (resp_tuple) ->
    [trigger, answer] = resp_tuple
    robot.respond trigger, (res) ->
      res.send answer

  listens.forEach (resp_tuple) ->
    [trigger, answer] = resp_tuple
    robot.hear trigger, (res) ->
      res.send answer

  rarelistens.forEach (resp_tuple) ->
    [trigger, answer] = resp_tuple
    robot.hear trigger, (res) ->
      if Math.random() < 0.2
        res.send answer

  reactions.forEach (resp_tuple) ->
    [trigger, answers] = resp_tuple
    robot.hear trigger, (res) ->
      answers.forEach (emoji) ->
        util.react res, emoji

  robot.topic (res) ->
    unless res.message.room == "general"
      res.send "'#{res.message.text}' ist ein #{res.random topic_adjectives} Channelthema."
