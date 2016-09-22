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
  # robot.hear /.*/, (msg) ->
  #   user = msg.message.user.name.toLowerCase()
  #   if user == donny
  #     msg.send msg.random walter_quotes

  robot.hear /matthias ist (.*)/i, (msg) ->
    raw_msg = msg.match[1]
    adj = raw_msg.toLowerCase()
    if adj.indexOf("die tür") == -1 and adj.indexOf("die tuer") == -1
      msg.reply "Deine Mudda ist #{raw_msg}!"

  robot.hear /matthias,? du bist (.*)/i, (msg) ->
    adj = msg.match[1].toLowerCase()
    msg.reply "Deine Mudda ist #{adj}!"

  robot.hear /matthias scheißt auf (.*)/i, (msg) ->
    term = msg.match[1]
    msg.reply "Deine Mudda scheißt auf #{term}!"

  robot.hear /bash me/i, (msg) ->
    msg.send "http://bash.fsrleaks.de/?#{randomRange(1, 946)}"

  robot.respond /random (\d*) (\d*)/i, (msg) ->
    min = msg.match[1]
    max = msg.match[2]
    robot.http("https://www.random.org/integers/?num=1&min=#{min}&max=#{max}&format=plain&col=1&base=10")
      .get() (err, res, body) ->
        msg.send(body.trim())

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
