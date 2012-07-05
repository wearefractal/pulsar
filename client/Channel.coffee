class Channel
  constructor: (@name, @socket) ->
    @listeners = []
    @events = {}
    @socket.send JSON.stringify
      channel: @name
      action: 'join'

  realEmit: (event, args...) =>
    return false unless @events[event]
    l args... for l in @events[event]
    return true

  emit: (event, args...) =>
    @socket.send JSON.stringify
      channel: @name
      event: event
      args: args
    return true

  addListener: (event, listener) =>
    @realEmit 'newListener', event, listener
    (@events[event]?=[]).push listener
    return @

  on: @::addListener

  once: (event, listener) =>
    fn = =>
      @removeListener event, fn
      listener arguments...
    @on event, fn
    return @

  removeListener: (event, listener) =>
    return @ unless @events[event]
    @events[event] = (l for l in @events[event] when l isnt listener)
    return @

  removeAllListeners: (event) =>
    delete @events[event]
    return @

module.exports = Channel