# Description:
#   Einfache trigger-response Interaktionen
#
# Dependencies:
#   ../util
#
# Commands:
#
# Author:
#   kiliankoe

util = require "../util"

responses = []

listens = [
  [/pimmel/i, "Höhöhö, du hast Pimmel gesagt."],
  [/jehova/i, "http://i.imgur.com/01PMBGj.gif"],
  [/^nein$/i, "Doch!"],
  [/wat is wacken\??/i, "Dat ist Wacken. Einmal im Jahr kommen hier alle bösen schwarzen Männer aus Mittelerde her, um ma richtig die Sau rauszulassen."],
  [/^marco$/i, "POLO"],
  [/\?$/i, "¯\\_(ツ)_/¯"]
]

rarelistens = [
  [/\sphp|^php/, "Naja, ich hab mit PHP auch schon richtig gut funktioni⍰\nParse error: syntax error, unexpected '::' (T_PAAMAYIM_NEKUDOTAYIM) in Command line code on line 1"],
  [/spiel|game/i, "ICH HAB' DAS SPIEL VERLOREN!"]
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
      if Math.random() < 0.05
        res.send answer
