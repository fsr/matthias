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

    reassign: (person, house, msg) ->
        house = house.toLowerCase()
        person = person.toLowerCase()
        if not @houses.has house
            msg.send "I don't know a house '#{house}'"
            return
        else if not @people.has person
            msg.send "I don't know any '#{person}'"
            return
        else
            person_obj = @people.get person.toLowerCase()
            person.house = house
            msg.send "#{person_obj.name} is now in #{@houses.get(house).name}."

    sorting_hat: (person, msg) ->
        person = person.toLowerCase()
        if not @people.has person
            msg.send "I don't know anyone named '#{person}'"
            return

        house_arr = Array.from(@houses.values())

        house = house_arr[Math.floor(Math.random() * house_arr.length)]

        person.house = house.name

        msg.send house.name.toUpperCase() + "!"


    modify_points: (thing, points, msg) ->
        if @people.has thing
            person = @people.get thing
            house_name = person.house.toLowerCase()
            name = person.name
        else if @houses.has thing
            house_name = thing
            name = "Someone"
        else
            msg.send "I neither know a person nor a house named '#{thing}'"
            return

        house = @houses.get house_name

        @award house, points

        action = if points < 0 then "lost" else "earned"
        points = Math.abs(points)

        msg.send "#{name} has just #{action} the house #{house.name} #{points} points. #{house.name} now has a grand total of #{house.points} points"


module.exports = (robot) ->
    ensure_ledger hogwarts_ledger
    hogwarts = from_file hogwarts_ledger

    robot.hear /(\d+) points(?: will be awarded)? to @?(\w+)/i, (msg) ->
        points = parseInt msg.match[1]
        matcher = msg.match[2].toLowerCase()
        hogwarts.modify_points(matcher, points, msg)

    robot.hear /(\d+) points(?: will be taken(?: away)?)? from (\w+)?/i, (msg) ->
        points = -1 * parseInt msg.match[1]
        matcher = msg.match[2].toLowerCase()
        hogwarts.modify_points(matcher, points, msg)

    robot.respond /(?:I (?:(?:will|should|want to) ))join(?: the \w+)? house (\w+)/, (msg) ->
        house = msg.match[1].toLowerCase()
        hogwarts.reassign(msg.message.user.name, house, msg)

    robot.respond /@?(\w+)(?: (?:joins|is joining|should join))?(?: the \w+)? house (\w+)/, (msg) ->
        house = msg.match[2].toLowerCase()
        person = msg.match[1].toLowerCase()
        if person == "i"
            return
        hogwarts.reassign(person, house, msg)

    robot.respond /(?:sorting hat|sort me)$/, (msg) ->
        hogwarts.sorting_hat(msg.message.user.name, msg)

    robot.respond /(?:sorting hat) (\w+)/, (msg) ->
        hogwarts.sorting_hat(msg.match[1], msg)
