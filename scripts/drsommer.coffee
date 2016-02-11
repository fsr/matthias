# Description:
#   Dr. Sommer
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Dr. Sommer, ich hab da mal ne Frage - Stelle eine anonyme Frage in #dr_sommer
#
# Author:
#   kiliankoe

module.exports = (robot) ->
  robot.hear /^(hey |hallo |lieber )?dr\.? sommer,?/i, (msg) ->
    robot.messageRoom '#dr_sommer', "\"#{msg.message.text}\" - #{msg.random names} (#{randomInt(10,15)})"

names = [
  "Shantalle",
  "Schackeline",
  "Tamara",
  "Cindy",
  "Jenny",
  "Clair-Gina",
  "Justin",
  "Jerome",
  "Chantal",
  "Jacqueline",
  "Yves",
  "Sylvia",
  "Claudia",
  "Dörte"
]

randomInt = (max, min)->
  return Math.floor(Math.random() * (max - min + 1)) + min
