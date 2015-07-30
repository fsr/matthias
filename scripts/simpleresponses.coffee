# Description:
#   Ein paar weitere kleine Antworten von matthias
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot bash me - Frag' hubot nach einem random Zitat link
#   hubot pizza - hubot nennt alle Details für eine Pizzabestellung (im Ratsaal)
#   hubot filmlist - Frag' hubot nach Links zu beiden Filmlisten
#
#
# Author:
#   kiliankoe


simpleresponses = [
  [/bash me/i, "http://bash.fsrleaks.de/?#{randomRange(1, 632)}"],
  [
    /pizza/i,
    "Ich bin Matthias Stuhlbein,
    Nöthnitzerstr. 46, 01187 Dresden.
    Fakultät Informatik. Mail: pizza@ifsr.de,
    Telefon: 0351 46338223 - Pizzen schneiden nicht vergessen ;)"
  ],
  [
    /filmlist/i,
    "Vorschläge: http://letterboxd.com/kiliankoe/list/ifsr-filmvorschlage/\n
    Geschaute Filme: http://letterboxd.com/kiliankoe/list/ifsr-movie-night/"],
  [
    /wat is wacken\?/i,
    "Dat ist Wacken.
    Einmal im Jahr kommen hier alle bösen schwarzen Männer aus Mittelerde her,
    um ma richtig die Sau rauszulassen."
  ],
  [/pimmel/, "Höhöhö, du hast Pimmel gesagt."],
  [/anyway/, "how's your sex life?"],
  [/jehova/i, "http://i.imgur.com/01PMBGj.gif"],
  [/frau/, ":lucas: Eh? :point_up:"],
  [/muss man wissen|fefe|sascha lobo|axel stoll/, "http://i.imgur.com/FmEyA8t.png"],
  [/schuh/, ":shoe::shoe:? Liegen wahrscheinlich noch bei Ben daheim."],
  [/you're tearing me apart|the room|tommy wiseau/, "http://i.giphy.com/pTrgmCL2Iabg4.gif"],
  [/citrix|35000|35.000|35k/, ":moneybag::moneybag::moneybag:"]
]


module.exports = (robot) ->
  robot.hear /(python|haskell|\sphp|^php)/i, (msg) ->
    lang = msg.match[1].toLowerCase()
    user = msg.message.user.name.toLowerCase()
    if user == "justus"
      msg.send "Ja, aber #{lang} ist ja auch keine ernstzunehmende Sprache..."
    else if lang == "php" or lang == " php"
      msg.send "Naja, ich hab mit PHP auch schon richtig gut funktioni⍰\nParse error: syntax error, unexpected '::' (T_PAAMAYIM_NEKUDOTAYIM) in Command line code on line 1"

  robot.hear /.*/, (msg) ->
    user = msg.message.user.name.toLowerCase()
    if user == donny
      msg.send msg.random walter_quotes

  robot.hear /schuh/i, (msg) ->
    msg.send ":shoe::shoe:? Liegen wahrscheinlich noch bei Ben daheim."

  simpleresponses.forEach (resp_tuple) ->
    [trigger, answer] = resp_tuple
    robot.hear trigger, (msg) ->
      msg.send answer


randomRange = (min, max) ->
  Math.floor(Math.random() * (max - min) + min)

donny = "slackbot"
walter_quotes = [
  "Shut the fuck up, #{donny}.",
  "Forget it, #{donny}, you're out of your element!",
  "#{donny}, you're out of your element!",
  "#{donny}, shut the f—",
  "That's ex-- Shut the fuck up, #{donny}!"
]
