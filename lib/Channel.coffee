class Channel
  constructor: (@name, @server) ->
    @server.on 'connection', (socket) =>
      socket.on 'message', (msg) =>
        try
          {channel, action} = JSON.parse msg
          return unless channel is @name and typeof action is 'string'
          @listeners.push socket if action is 'join'
        catch e
          throw e

      socket.on 'message', (msg) =>
        try
          {channel, event, args} = JSON.parse msg
          return unless channel is @name
          args = [args] unless Array.isArray args
          @realEmit event, args...
        catch e
          throw e

  listeners: []
  events: {}
  realEmit: (event, args...) ->
    return false unless @events[event]
    l args... for l in @events[event]
    return true

  emit: (event, args...) ->
    for socket in @listeners
      socket.send JSON.stringify
        channel: @name
        event: event
        args: args
    return true

  addListener: (event, listener) ->
    @emit 'newListener', event, listener
    (@events[event]?=[]).push listener
    return @

  on: @::addListener

  once: (event, listener) ->
    fn = =>
      @removeListener event, fn
      listener arguments...
    @on event, fn
    return @

  removeListener: (event, listener) ->
    return @ unless @events[event]
    @events[event] = (l for l in @events[event] when l isnt listener)
    return @

  removeAllListeners: (event) ->
    delete @events[event]
    return @

module.exports = Channel