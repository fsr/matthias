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
feed = require 'feed-read'

dudle_db = "./data/dudle.json"


module.exports = (robot) ->

    new cronjob('00 */10 * * * *', ->
        check_all_dudles(robot)
    , null, true, "Europe/Berlin")

    robot.respond /subscribe (.*)/i, (msg) ->
        match = msg.match[1]
        # shortname_from_link returns same content early if it's not a link
        shortname = shortname_from_link match
        dudle_link = make_valid_dudle_link match
        # TODO: Theoretically one could validate the dudle itself here as well.
        # Otherwise it will get removed after <10 minutes automatically
        # But the user won't be any smarter...
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
        dudles.forEach (dudle) ->
            msg.send "#{dudle.shortname}: #{dudle.url}"

    robot.respond /dudle (.*)/i, (msg) ->
        shortname = msg.match[1]
        dudle_link = "https://dudle.inf.tu-dresden.de/#{shortname}/"
        robot.http(dudle_link)
            .get() (err, res, body) ->
                if res.statusCode != 200
                    msg.send 'Sieht nicht so aus, als ob das Dudle (noch) existiert.'
                    return

                totals = parse_totals body
                if totals.size == 0
                    msg.send 'Das Dudle scheint leer zu sein...'
                    return

                msg.send 'Hab folgende Resultate gefunden:'
                totals.forEach (el, count) ->
                    msg.send "Option #{el} mit #{count} Stimmen"

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
    read_dudles_file().has shortname

read_dudles_file = ->
    try
        dudles = new Map(JSON.parse(fs.readFileSync(dudle_db)).map((dudle) -> [dudle.shortname, dudle]))
    catch err
        dudles = new Map()
        console.log "Couldn't find #{dudle_db}"
    dudles

write_dudles_file = (dudle_map) ->
    values = []
    for val in dudle_map.values()
        values.push(val)
    try
        fs.writeFile(dudle_db, JSON.stringify(values, null, 2), -> null)
    catch err
        console.log "Couldn't write to #{dudle_db}: #{err}"



save_dudle_to_file = (shortname, url) ->
    dudles = read_dudles_file()
    new_dudle =
        shortname: shortname
        url: url
        last_checked: new Date().toISOString()
    dudles.set shortname, new_dudle
    write_dudles_file dudles

remove_dudle_from_file = (shortname) ->
    dudles = read_dudles_file()

    if dudles.has shortname
        dudles.delete shortname
        write_dudles_file dudles
        true
    else
        false

update_dudle_date = (shortname, date) ->
    dudles = read_dudles_file()
    dudles.get(shortname).last_checked = date.toISOString()
    write_dudles_file dudles

check_all_dudles = (robot) ->
    dudles = read_dudles_file()
    dudles.forEach (dudle) ->
        check_dudle_feed dudles, dudle, (events) ->
            if events.length > 0
                publish_events robot, dudle, events
    write_dudles_file dudles

check_dudle_feed = (map, dudle, event_callback) ->
    atom_url = dudle.url + "atom.cgi"
    feed atom_url, (err, articles) ->
        if err != null
            console.log "Feed for dudle #{dudle.shortname} not found. Removing it from list."
            map.delete dudle.shortname
        else
            last_checked = new Date(dudle.last_checked)
            last_updated = articles.first().published
            now = new Date()
            now.addHours 1
            dudle.last_checked = now
            event_callback(articles
                            .filter((article) -> last_checked < article.published)
                            .map((article) -> article.title))


publish_events = (robot, dudle, events) ->
    robot.messageRoom '#dudle', "Neues zum Dudle #{dudle.shortname}:"
    events = events.reverse() # let's do this in chronological order
    for e in events
        robot.messageRoom '#dudle', e
    robot.messageRoom '#dudle', "Mehr Infos direkt hier: #{dudle.url}"

parse_totals = (body) ->
    $ = cheerio.load body

    header_rows = $('#participanttable > thead > tr:nth-child(2)').children()
    header_items = elements_of_column header_rows

    summary_rows = $('#summary').children()
    summary_items = elements_of_column summary_rows

    totals = new Map()
    for i in [0..header_items.length - 1]
        totals.set(header_items[i], summary_items[i])
    totals

elements_of_column = (row) ->
    Array.from(row.slice(1, row.length - 1)).map((column) -> column.children[0].data)


# stuffjsdoesnthave.tumblr.com
if !Array.prototype.last
    Array.prototype.last = ->
        return this[this.length - 1]
    Array.prototype.first = ->
        return this[0]

Date.prototype.addHours = (h) ->
   this.setTime(this.getTime() + (h*60*60*1000))
   return this
