counter = 0

class Channel
  constructor: (@name, @socket) ->
    @__id = counter++
    console.log "#{@__id}: new channel"
    @events = {}
    @stack = []
    @joinChannel()

  joinChannel: ->
    if @socket
      @socket.write
        type: 'join'
        channel: @name
      @socket.once "close", =>
        @joined = false
    else
      @joined = true
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

    console.log "#{@__id}: sending #{event} to #{@listeners?.length} listeners"
    if @listeners
      socket.write msg for socket in @listeners
      return true
    else if @socket
      console.log "#{@__id}: sending #{event} to socket"
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

  removeSocketListener: (listener) ->
    return @ unless @listeners
    @listeners = (l for l in @listeners when l isnt listener)
    @emit 'unjoin', listener
    @realEmit 'unjoin', listener
    return @

  removeListener: (event, listener) =>
    return @ unless @events[event]
    @events[event] = (l for l in @events[event] when l isnt listener)
    return @

  removeAllListeners: (event) =>
    delete @events[event]
    return @

  ready: (fn) =>
    if @joined
      fn @
    else
      @once 'join', => fn @

  use: (fn) => @stack.push(fn); @
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

module.exports = Channel
