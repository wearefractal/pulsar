isBrowser = typeof window isnt 'undefined'

class Channel
  constructor: (@name, @socket) ->
    @events = {}
    @stack = []
    if @socket
      @socket.write
        type: 'join'
        channel: @name
    else
      @listeners = []

  realEmit: (event, args...) =>
    @runStack event, args, (nargs) =>
      return false unless @events[event]
      l nargs... for l in @events[event]
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

  use: (fn) -> @stack.push(fn); @
  runStack: (event, args, cb) =>
    return cb args if @stack.length is 0
    return cb args if event is 'newListener'
    idx = -1
    emit = (argv...) =>
      args = argv unless argv.length is 0
      next = @stack[++idx]
      return cb args unless next?
      next emit, event, args...
    emit args...
    return

if isBrowser
  window.PulsarChannel = Channel
else
  module.exports = Channel