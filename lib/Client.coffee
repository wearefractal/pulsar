Channel = require './Channel'

client =
  options:
    namespace: 'Pulsar'
    resource: 'default'

  start: ->
    @channels = {}
    @on "reconnected", =>
      for name, chan of @channels
        chan.joinChannel()

  channel: (name) ->
    @channels[name] ?= new Channel name, @ssocket

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

module.exports = client
