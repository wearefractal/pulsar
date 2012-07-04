ServerChannel = require '../lib/Channel'
class Channel extends ServerChannel
  constructor: (@name, @socket) ->
    @listeners = []
    @events = {}
    @socket.send JSON.stringify
      channel: @name
      action: 'join'

  emit: (event, args...) =>
    @socket.send JSON.stringify
      channel: @name
      event: event
      args: args
    return true

module.exports = Channel