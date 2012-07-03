ServerChannel = require '../lib/Channel'
class Channel extends ServerChannel
  constructor: (@name, @socket) ->
    @socket.send JSON.stringify
      channel: @name
      action: 'join'
    @socket.on 'message', (msg) =>
      try
        {channel, event, args} = JSON.parse msg
        return unless channel is @name
        args = [args] unless Array.isArray args
        @realEmit event, args...
      catch e
        throw e

  emit: (event, args...) ->
    @socket.send JSON.stringify
      channel: @name
      event: event
      args: args
    return true

module.exports = Channel