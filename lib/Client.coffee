isBrowser = typeof window isnt 'undefined'

Channel = (if isBrowser then PulsarChannel else require './Channel')

client =
  options:
    namespace: 'Pulsar'
    resource: 'default'

  connectAttempts: 0

  start: ->
    @channels = {}

  channel: (name) ->
    @channels[name] ?= new Channel name, @ssocket

  # if we just got a new socket, reconnect the channels
  connect: (socket) ->
    @connectAttempts++

    reconnectChannels = =>
      for name, channel of @channels
        @channels[name] = new Channel name, socket
        @channels[name].listeners = channel.listeners
        @channels[name].events = channel.events
        @channels[name].stack = channel.stack

    setTimeout reconnectChannels, 100 if @connectAttempts > 1

  validate: (socket, msg, done) ->
    return done false unless typeof msg is 'object'
    return done false unless typeof msg.type is 'string'
    switch msg.type
      when 'emit'
        return done false unless typeof msg.channel is 'string'
        return done false unless typeof @channels[msg.channel]?
        return done false unless typeof msg.event is 'string'
        return done false unless Array.isArray msg.args
      when 'joined'
        return done false unless typeof msg.channel is 'string'
        return done false unless typeof @channels[msg.channel]?
      else
        return done false
    return done true

  error: (socket, err) -> @emit 'error', err, socket
  message: (socket, msg) ->
    chan = @channels[msg.channel]
    switch msg.type
      when 'emit'
        chan.realEmit msg.event, msg.args...
      when 'joined'
        chan.joined = true
        chan.realEmit 'join'

if isBrowser
  window.Pulsar = createClient: ProtoSock.createClientWrapper client
else
  module.exports = client
