# Description:
#   Der Techniker ist informiert.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot türstatus - hubot schaut nach, wie es um die Tür des APB steht.
#   hubot ist die tür kaputt? - hubot schaut nach, wie es um die Tür des APB steht.
#   hubot glasschaden - teile hubot mit, dass die Tür mal wieder im Eimer ist.
#   hubot rate mal, was wieder kaputt ist - teile hubot mit, dass die Tür mal wieder im Eimer ist.
#   hubot techniker ist informiert - teile hubot mit, dass die Tür mal wieder im Eimer ist.
#   hubot tür ist wieder ganz - teile hubot mit, dass die Tür wieder ganz ist
#   hubot tür ist weg - teile hubot mit, dass die Tür sich in einem unbekannten Status befindet.
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /türstatus|tuerstatus|ist die tür kaputt?|ist die tuer kaputt?/i, (msg) ->
    checkDoor(robot, msg)

  robot.respond /glasschaden|rate mal, was wieder kaputt ist|techniker ist informiert/i, (msg) ->
    setDoor(robot, "yes")

  robot.respond /tür ist wieder ganz|tuer ist wieder ganz/i, (msg) ->
    setDoor(robot, "no")

  robot.respond /tür ist weg|tuer ist weg/i, (msg) ->
    setDoor(robot, "maybe")

checkDoor = (robot, msg) ->
  robot.http('http://tuer.fsrleaks.de')
    .get() (err, res, body) ->
      if body.indexOf("Ja") > -1
        msg.send msg.random yesMsgs
      else if body.indexOf("Nein") > -1
        msg.send msg.random noMsgs
      else
        msg.send msg.random maybeMsgs


setDoor = (robot, state) ->
  robot.http("http://door.fsrleaks.de/set.php?#{state}").get() (err, res, body) ->
    return

yesMsgs = [
  "Jop, Tür ist im Eimer.",
  "Tür ist 'putt.",
  "Rate mal...",
  "Alles im Arsch, Normalzustand halt.",
  "Computer sagt: Tür ist hin.",
  "Tür pass auf!! Du hast ne Scheibe verloren!",
  "Techniker ist selbstverständlich bereits informiert."
]

noMsgs = [
  "Die Tür ist... ganz?!",
  "Alles im grünen Bereich.",
  "Sie ist ganz! Also... Zumindest gerade eben. Vermutlich schon nicht mehr.",
  "Rufe Fr. Kapplusch an... Nop, scheint alles gut zu sein. Beeindruckend.",
  "Hab' eben nachgesehen und... Ausnahmezustand!"
]

maybeMsgs = [
  "Ich hab keine Ahnung ¯\\_(ツ)_/¯",
  "Sorry, musst du dieses Mal selber nachschauen.",
  "Quizás, señor/a.",
  "Sorry, no clue.",
  "Schrödingers Tür?",
  "Lässt sich aus diesem Blickwinkel schlecht beurteilen."
]
