# this is not a plugin, but some helper funtions for working with hubot

module.exports.react = (res, emoji) ->
  if res.robot?.adapter?.client?.web?.reactions?.add?
    res.robot.adapter.client.web.reactions.add(emoji, {channel: res.message.room, timestamp: res.message.id})
  else
    res.send emoji
