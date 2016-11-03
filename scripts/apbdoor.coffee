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
#   hubot tür ist ganz - teile hubot mit, dass die Tür wieder ganz ist.
#   hubot tür ist kaputt - teile hubot mit, dass die Tür im Eimer ist.
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /t(?:ü|ue)rstatus/i, (msg) ->
    checkDoor(robot, msg)

  robot.respond /t(?:ü|ue)r (?:ist )?(.*)/, (msg) ->
    state = msg.match[1].toLowerCase()
    switch state
      when "kaputt", "broken", "im eimer"
        setDoor(robot, "yes")
        msg.send "Orr ne, schon wieder?!"
      when "ganz", "wieder ganz", "funktional"
        setDoor(robot, "no")
        msg.send msg.random partyGifs
      when "weg", "unbekannt"
        setDoor(robot, "maybe")
        msg.send "Ähm... Ahja?"
      else
        msg.send "Keine Ahnung, was du damit meinst. Ist die Tür kaputt, ganz oder weg?"

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

partyGifs = [
  "http://i.giphy.com/6nuiJjOOQBBn2.gif",
	"http://i.giphy.com/EktbegF3J8QIo.gif",
	"http://i.giphy.com/YTbZzCkRQCEJa.gif",
	"http://i.giphy.com/3rgXBQIDHkFNniTNRu.gif",
	"http://i.giphy.com/s2qXK8wAvkHTO.gif"
]
