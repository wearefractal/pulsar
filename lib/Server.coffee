Channel = require './Channel'

module.exports = (opt) ->
  out =
    options:
      namespace: 'Pulsar'
      resource: 'default'

    start: ->
      @channels = {}

    channel: (name) ->
      @channels[name] ?= new Channel name

    inbound: (socket, msg, done) ->
      try
        done JSON.parse msg
      catch err
        @error socket, err

    outbound: (socket, msg, done) ->
      try
        done JSON.stringify msg
      catch err
        @error socket, err

    validate: (socket, msg, done) ->
      return done false unless typeof msg is 'object'
      return done false unless typeof msg.type is 'string'
      if msg.type is 'emit'
        return done false unless typeof msg.channel is 'string'
        return done false unless typeof @channels[msg.channel]?
        return done false unless typeof msg.event is 'string'
        return done false unless Array.isArray msg.args
      else if msg.type is 'join'
        return done false unless typeof msg.channel is 'string'
        return done false unless typeof @channels[msg.channel]?
      else if msg.type is 'unjoin'
        return done false unless typeof msg.channel is 'string'
        return done false unless typeof @channels[msg.channel]?
      else
        return done false
      return done true

    invalid: (socket, msg) -> socket.close()

    message: (socket, msg) ->
      try
        chan = @channels[msg.channel]
        if msg.type is 'emit'
          chan.realEmit msg.event, msg.args...
        else if msg.type is 'join'
          # TODO: Pass an eventemitter instead of socket
          chan.listeners.push socket
          chan.realEmit 'join', socket
        else if msg.type is 'unjoin'
          # TODO: remove socket from chan.listeners
          chan.realEmit 'unjoin', socket
      catch err
        @error socket, err

  out.options[k]=v for k,v of opt
  return out