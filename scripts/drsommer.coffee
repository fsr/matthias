# Description:
#   Dr. Sommer
#
# Configuration:
#   HUBOT_DRSOMMER_ROOM, defaults to "dr_sommer"
#
# Commands:
#   Dr. Sommer, ich hab da mal ne Frage - Stelle eine anonyme Frage in #dr_sommer
#
# Author:
#   kiliankoe

drsommer_room = process.env.HUBOT_DRSOMMER_ROOM or "dr_sommer"

module.exports = (robot) ->
  robot.hear /^(hey |hallo |lieber )?dr\.? sommer,?/i, (msg) ->
    robot.messageRoom drsommer_room, "\"#{msg.message.text}\" - #{msg.random names} (#{randomInt(10,15)})"

  # help matthias respond to priv messages as well
  robot.respond /(hey |hallo |lieber )?dr\.? sommer,?/i, (msg) ->
    question = msg.message.text.replace("matthias ", "")
    robot.messageRoom drsommer_room, "\"#{question}\" - #{msg.random names} (#{randomInt(10,15)})"

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

randomInt = (max, min) ->
  return Math.floor(Math.random() * (max - min + 1)) + min
