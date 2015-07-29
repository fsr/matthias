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
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /bash me/i, (msg) ->
    msg.send "http://bash.fsrleaks.de/?#{randomRange(1, 632)}"

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

randomRange = (min, max) ->
  Math.floor(Math.random() * (max - min) + min)

donny = "slackbot"
walter_quotes = [
  "Shut the fuck up, #{donny}.",
  "Forget it, #{donny}, you're out of your element!",
  "#{donny}, you're out of your element!",
  "#{donny}, shut the f— when do we play?",
  "That's ex-- Shut the fuck up, #{donny}!"
]
