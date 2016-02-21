# Description:
#   dudle
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot watch <dudle> - Poste Updates zu <dudle> in #dudle
#   hubot dudle <dudle> - Hole aktuelle Ergebnisse zu <dudle>
#
# Author:
#   kiliankoe

fs = require 'fs'
cronjob = require('cron').CronJob

module.exports = (robot) ->

    new cronjob('00 */10 * * * *', ->
        check_all_dudles(robot)
    , null, true, "Europe/Berlin")

    robot.respond /watch (.*)/i, (msg) ->
        dudle_link = msg.match[1]
        shortname = shortname_from_link dudle_link
        save_dudle_to_file shortname, dudle_link
        msg.send("Ok, ich poste Updates zu #{shortname} in #dudle.")

    robot.respond /dudle (.*)/i, (msg) ->
        msg.send "Das Feature kommt noch :)"

shortname_from_link = (link) ->
    link_elements = link.split('/') # TODO: Remove possible trailing '/' before doing this
    link_elements.last()

read_dudles_file = ->
    dudles = []
    try
        dudles = JSON.parse(fs.readFileSync('./data/dudle.json'))
    catch err
        console.log "Coulnd't find dudle.json"
    dudles

save_dudle_to_file = (shortname, url) ->
    dudles = read_dudles_file()
    new_dudle =
        "shortname": shortname,
        "url": url,
        "last_checked": new Date().toISOString() # TODO: Set this date in the past
    dudles.push new_dudle
    try
        fs.writeFile('./data/dudle.json', JSON.stringify(dudles, null, 2))
    catch err
        console.log "Couldn't write to dudle.json"

check_all_dudles = (robot) ->
    dudles = read_dudles_file()
    dudles.forEach (dudle) ->
        events = check_dudle_feed dudle
        publish_events robot, dudle, events

check_dudle_feed = (dudle) ->
    atom_url = dudle.url + "/atom.cgi"
    # TODO: Fetch and parse feed
    # TODO: Remove dudle from list if 404
        # Actually... We're probably the ones preventing this from happening
        # It might be better to remove dudles after a period of inactivity
    # TODO: Return list of new events

publish_events = (robot, dudle, events) ->
    # TODO: Send messages for all events for a specific dudle


# stuffjsdoesnthave.tumblr.com
if !Array.prototype.last
    Array.prototype.last = ->
        return this[this.length - 1]
