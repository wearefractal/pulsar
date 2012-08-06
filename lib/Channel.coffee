isBrowser = typeof window isnt 'undefined'

class Channel
  constructor: (@name, @socket) ->
    @events = {}
    if @socket
      @socket.write
        type: 'join'
        channel: @name
    else
      @listeners = []

  realEmit: (event, args...) =>
    return false unless @events[event]
    l args... for l in @events[event]
    return true

  emit: (event, args...) =>
    msg =
      type: 'emit'
      channel: @name
      event: event
      args: args

    if @listeners
      socket.write msg for socket in @listeners
      return true
    else if @socket
      @socket.write msg
      return true
    else
      return false

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

if isBrowser
  window.PulsarChannel = Channel
else
  module.exports = Channel