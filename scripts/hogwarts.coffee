# Description:
#   Hogwarts related functionality
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <n> points to <person> - award <person> <n> points
#
# Author:
#   Justus Adam <me@justus.science>


fs = require 'fs'

hogwarts_ledger = process.env.HUBOT_HOGWARTS_LEDGER or './data/hogwarts.json'


map_to_obj = (m) ->
    o = new Object(null)
    m.forEach (value, key) ->
        o[key] = value
    o


obj_to_map = (o) ->
    m = new Map()
    for key, value in o
        m.set key, value
    m


ensure_ledger = (ledger_file) ->
    if not fs.existsSync ledger_file
        fs.closeSync fs.openSync(hogwarts_ledger, 'w')


from_file = (file) ->
    deserialise_hogwarts JSON.parse(fs.readFileSync(file)), file


serialise_hogwarts = (hog) ->
    obj = new Object(null)

    obj.people = Array.from(hog.people.values())
    obj.houses = Array.from(hog.houses.values())
    obj


map_to = (arr, f) ->
    m = new Map()

    arr.forEach (val) ->
        m.set f(val), val
    m


deserialise_hogwarts = (obj, file) ->
    to_l_name = (p) -> p.name.toLowerCase()
    new Hogwarts(
        map_to(obj.houses, to_l_name),
        map_to(obj.people, to_l_name),
        file
    )


class Hogwarts
    constructor: (houses, people, file) ->
        @houses = houses
        @people = people
        @file = file

    award: (house, points) ->
        house.points += points
        @write(-> null)

    write: (callback) ->
        fs.writeFile @file, JSON.stringify(serialise_hogwarts(this), null, 2), callback

    query: (person) ->
        @people.get person

    modify_points: (thing, points, msg) ->
        if @people.has thing
            person = @people.get thing
            house_name = person.house.toLowerCase()
            name = person.name
        else if @houses.has thing
            house_name = thing
            name = "Someone"
        else
            return

        house = @houses.get house_name

        @award house, points

        action = if points < 0 then "lost" else "earned"
        points = Math.abs(points)

        msg.send "#{name} has just #{action} the house #{house.name} #{points} points. #{house.name} now has a grand total of #{house.points} points"


module.exports = (robot) ->
    ensure_ledger hogwarts_ledger
    hogwarts = from_file hogwarts_ledger

    robot.hear /(\d+) points to @?(\w+)/i, (msg) ->
        points = parseInt msg.match[1]
        matcher = msg.match[2].toLowerCase()
        hogwarts.modify_points(matcher, points, msg)


    robot.hear /(\d+) points(?: will be taken(?: away)?)? from (\w+)?/i, (msg) ->
        points = -1 * parseInt msg.match[1]
        matcher = msg.match[2].toLowerCase()
        hogwarts.modify_points(matcher, points, msg)
