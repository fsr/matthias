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
#   hubot subscribe <dudle> - Poste Updates zu <dudle> in #dudle
#   hubot unsubscribe <dudle> - Poste keine weiteren Updates zu <dudle>
#   hubot dudlelist - Welche Dudles werden aktuell beobachtet?
#   hubot dudle <dudle> - Hole aktuelle Ergebnisse zu <dudle>
#
# Author:
#   kiliankoe

fs = require 'fs'
cronjob = require('cron').CronJob
cheerio = require 'cheerio'
url = require 'url'

module.exports = (robot) ->

    new cronjob('00 */10 * * * *', ->
        check_all_dudles(robot)
    , null, true, "Europe/Berlin")

    robot.respond /subscribe (.*)/i, (msg) ->
        match = msg.match[1]
        # shortname_from_link returns same content early if it's not a link
        shortname = shortname_from_link match
        dudle_link = make_valid_dudle_link match
        if is_already_subscribed shortname
            msg.send 'Das tracke ich bereits.'
        else
            save_dudle_to_file shortname, dudle_link
            msg.send "Ok, ich poste Updates zu #{shortname} in #dudle."

    robot.respond /unsubscribe (.*)/i, (msg) ->
        shortname = msg.match[1]
        found = remove_dudle_from_file shortname
        if found
            msg.send "Ok, tracke #{shortname} nicht mehr."
        else
            msg.send "Tracke aktuell nichts mit diesem Namen."

    robot.respond /dudlelist/i, (msg) ->
        msg.send 'Aktuell tracke ich folgende Dudles:'
        dudles = read_dudles_file()
        for dudle in dudles
            msg.send "#{dudle.shortname}: #{dudle.url}"

    robot.respond /dudle (.*)/i, (msg) ->
        shortname = msg.match[1]
        dudle_link = "https://dudle.inf.tu-dresden.de/#{shortname}/"
        robot.http(dudle_link)
            .get() (err, res, body) ->
                if res.statusCode != 200
                    msg.send 'Sieht nicht so aus, als ob das Dudle (noch) existiert.'
                else
                    totals = parse_totals body
                    num_elements = Object.keys(totals).length # what kind of syntax is this?!
                    if num_elements > 0
                        msg.send 'Hab folgende Resultate gefunden:'
                        for el, count of totals
                            msg.send "Option #{el} mit #{count} Stimmen"
                    else
                        msg.send 'Das Dudle scheint leer zu sein...'

shortname_from_link = (link) ->
    if !is_dudle_url link
        return link
    if has_trailing_slash link
        link = link.slice 0, -1 # the easy way out^^
    link_elements = link.split('/')
    link_elements.last()

make_valid_dudle_link = (str) ->
    if is_dudle_url str
        if !has_trailing_slash str
            str += '/'
    else
        str = "https://dudle.inf.tu-dresden.de/#{str}/"
    str

is_dudle_url = (str) ->
    pattern = /dudle\.inf\./
    pattern.test str

has_trailing_slash = (str) ->
    pattern = /\/$/
    pattern.test str

is_already_subscribed = (shortname) ->
    dudles = read_dudles_file()
    found = false
    for dudle in dudles
        if dudle.shortname == shortname
            found = true
            break
    found

read_dudles_file = ->
    dudles = []
    try
        dudles = JSON.parse(fs.readFileSync('./data/dudle.json'))
    catch err
        console.log "Couldn't find dudle.json"
    dudles

write_dudles_file = (dudle_list) ->
    try
        fs.writeFile('./data/dudle.json', JSON.stringify(dudle_list, null, 2))
    catch err
        console.log "Couldn't write to dudle.json: #{err}"

save_dudle_to_file = (shortname, url) ->
    dudles = read_dudles_file()
    new_dudle =
        "shortname": shortname,
        "url": url,
        "last_checked": new Date().toISOString() # TODO: Set this date in the past
    dudles.push new_dudle
    write_dudles_file dudles

remove_dudle_from_file = (shortname) ->
    dudles = read_dudles_file()
    new_dudle_list = []
    found = false
    for dudle in dudles
        if shortname != dudle.shortname
            new_dudle_list.push dudle
        else
            found = true
    write_dudles_file new_dudle_list
    found

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

publish_events = (robot, shortname, events) ->
    robot.messageRoom '#dudle', "Neues zum Dudle #{shortname}"
    for e in events
        robot.messageRoom '#dudle', e

parse_totals = (body) ->
    $ = cheerio.load body

    header_rows = $('#participanttable > thead > tr:nth-child(2)').children()
    header_items = elements_of_column header_rows

    summary_rows = $('#summary').children()
    summary_items = elements_of_column summary_rows

    totals = {}
    for i in [0..header_items.length - 1]
        totals[header_items[i]] = summary_items[i]
    totals

elements_of_column = (row) ->
    elements = []
    for column in row.slice 1, row.length - 1
        elements.push column.children[0].data
    elements


# stuffjsdoesnthave.tumblr.com
if !Array.prototype.last
    Array.prototype.last = ->
        return this[this.length - 1]
