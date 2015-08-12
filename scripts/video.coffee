# Description:
#   Google video search
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot video me <query> - search Google for videos
#
#
# Author:
#   lucaswo

module.exports = (robot) ->
  robot.respond /(video)( me)? (.*)/i, (msg) ->
    videoMe msg, msg.match[3], (url) ->
      msg.send url

videoMe = (msg, query, cb) ->
    q = v: '1.0', rsz: '8', q: query, safe: 'active'
    msg.http('https://ajax.googleapis.com/ajax/services/search/video')
        .query(q)
        .get() (err, res, body) ->
            if err
                msg.send "Encountered an error :( #{err}"
                return
            if res.statusCode isnt 200
                msg.send "Bad HTTP response :( #{res.statusCode}"
                return
            videos = JSON.parse(body)
            videos = videos.responseData?.results
            if videos?.length > 0
                video = msg.random videos
                cb video.url
