# Description:
#   FSR Krams
#
# Dependencies:
#   ../util
#
# Commands:
#   hubot ese - Datum der nächsten ESE
#   hubot jemand da? - Ist aktuell jemand im Büro?
#   hubot buerostatus - Bürostatusgraph der letzten 6 Stunden
#
# Author:
#   kiliankoe

util = require "../util"

module.exports = (robot) ->
  robot.respond /ese/i, (res) ->
    currentdate = new Date()
    eseyear = currentdate.getFullYear()

    newyears = new Date("#{eseyear + 1}-01-01 00:00:00")
    difftony = Math.floor((newyears - currentdate)/1000/3600/24)
    if difftony <= 91
        eseyear += 1

    esedate = new Date("#{eseyear}-10-01 9:00:00")
    datediff = esedate - currentdate

    days = Math.floor(datediff/1000/60/60/24)
    datediff -= days*24*3600*1000
    hours = Math.floor(datediff/1000/60/60)
    datediff -= hours*3600*1000
    minutes = Math.floor(datediff/1000/60)
    res.send "Nur noch #{days} Tage, #{hours} Stunden und #{minutes} Minuten bis zur ESE #{eseyear}. Vermutlich :stuck_out_tongue_winking_eye:"

  robot.respond /(?:jemand|wer) da(?:\\?)/i, (res) ->
    robot.http('https://www.ifsr.de/buerostatus/output.php')
      .get() (err, response, body) ->
        if body.trim() == "1"
          util.react res, "thumbsup"
        else if body.trim() == "0"
          util.react res, "thumbsdown"
        else
          res.send "Keine Ahnung, @sebastian hat schon wieder unerwartet was geändert!"

  robot.respond /b(?:ü|ue)ro(?:status)?/i, (res) ->
    res.send('https://www.ifsr.de/buerostatus/image.php?h=6')

  robot.hear /sind wir beschlussf(?:ä|ae)hig/i, (res) ->
    res.send("Einmal durchzählen, bitte! Ich fang' an, 0!")
