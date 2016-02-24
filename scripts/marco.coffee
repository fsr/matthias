# Description:
#   Marco - Polo
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot marco - answers "POLO"
#
# Author:
#   Justus Adam <dev@justus.science>


module.exports = (robot) ->
    robot.respond /marco\s*/i, (msg) ->
        msg.send "POLO"
