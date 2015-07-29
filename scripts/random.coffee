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


module.exports = (robot) ->
  robot.respond /bash me/i, (msg) ->
    msg.send "http://bash.fsrleaks.de/?#{randomRange(1, 632)}"

  robot.respond /pizza/i, (msg) ->
    msg.send "Ich bin Matthias Stuhlbein, Nöthnitzerstr. 46, 01187 Dresden. Fakultät Informatik. Mail: pizza@ifsr.de, Telefon: 0351 46338223 - Pizzen schneiden nicht vergessen ;)"

  robot.respond /filmlist/i, (msg) ->
    msg.send "Vorschläge: http://letterboxd.com/kiliankoe/list/ifsr-filmvorschlage/\nGeschaute Filme: http://letterboxd.com/kiliankoe/list/ifsr-movie-night/"

  robot.respond /wat is wacken?/i, (msg) ->
    msg.send "Dat ist Wacken. Einmal im Jahr kommen hier alle bösen schwarzen Männer aus Mittelerde her, um ma richtig die Sau rauszulassen."

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

  robot.hear /pimmel/i, (msg) ->
    msg.reply "Höhöhö, du hast Pimmel gesagt."

  robot.hear /anyway/i, (msg) ->
    msg.reply "How's your sex life?"

  robot.hear /jehova/i, (msg) ->
    msg.send "http://i.imgur.com/01PMBGj.gif"

  robot.hear /frau/i, (msg) ->
    msg.send ":lucas: Eh? :point_up:"

  robot.hear /muss man wissen|fefe|sascha lobo|axel stoll/i, (msg) ->
    msg.send "http://i.imgur.com/FmEyA8t.png"

  robot.hear /schuh/i, (msg) ->
    msg.send ":shoe::shoe:? Liegen wahrscheinlich noch bei Ben daheim."

  robot.hear /you're tearing me apart|the room|tommy wiseau/i, (msg) ->
    msg.send "http://i.giphy.com/pTrgmCL2Iabg4.gif"

  robot.hear /citrix|35000|35.000|35k/, (msg) ->
    msg.send ":moneybag::moneybag::moneybag:"

  robot.hear /matthias ist (.*)/, (msg) ->
    adj = msg.match[1]
    if adj.indexOf("die t") == -1
      msg.reply "Deine Mudda ist #{adj}!"

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
