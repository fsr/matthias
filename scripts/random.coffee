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
#   hubot random <min> <max> - Frag' hubot nach einer Zufallszahl zwischen <min> und <max> (nutzt random.org)
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.hear /(python|haskell)/i, (msg) ->
    lang = msg.match[1].toLowerCase()
    user = msg.message.user.name.toLowerCase()
    if user == "justus"
      msg.send "Ja, aber #{lang} ist ja auch keine ernstzunehmende Sprache..."

  robot.hear /.*/, (msg) ->
    user = msg.message.user.name.toLowerCase()
    if user == donny
      msg.send msg.random walter_quotes

  robot.hear /matthias ist (.*)/i, (msg) ->
    adj = msg.match[1].toLowerCase()
    if adj.indexOf("die tür") == -1 and adj.indexOf("die tuer") == -1
      msg.reply "Deine Mudda ist #{adj}!"

  robot.hear /matthias,? du bist (.*)/i, (msg) ->
    adj = msg.match[1].toLowerCase()
    msg.reply "Deine Mudda ist #{adj}!"

  robot.hear /matthias scheißt auf (.*)/i, (msg) ->
    term = msg.match[1]
    msg.reply "Deine Mudda scheißt auf #{term}!"

  robot.hear /bash me/i, (msg) ->
    msg.send "http://bash.fsrleaks.de/?#{randomRange(1, 632)}"

  robot.respond /random (\d*) (\d*)/i, (msg) ->
    min = msg.match[1]
    max = msg.match[2]
    robot.http("https://www.random.org/integers/?num=1&min=#{min}&max=#{max}&format=plain&col=1&base=10")
      .get() (err, res, body) ->
        msg.send(body.trim())

  robot.respond /catfact/i, (msg) ->
    robot.send({room: msg.envelope.user.name}, "You have now been subscribed to Cat Facts. Type 'Tyxt33358dgggyf' to unsubscribe.")
    setTimeout () ->
      robot.send({room: msg.envelope.user.name}, "In ancient Egypt killing a cat was a crime punishable by death. Thanks for choosing Cat Facts!")
    , 5 * 1000

  robot.respond /Tyxt33358dgggyf/, (msg) ->
    msg.send "Command not recognized. You have a 2 year subscription to Cat Facts and will receive fun hourly updates!"
    setTimeout () ->
      msg.send "Did you know that the first cat show was held in 1871 at the Crystal Palace in London? Mee-wow!"
    , 3600 * 1000


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
