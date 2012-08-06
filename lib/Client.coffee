isBrowser = typeof window isnt 'undefined'

Channel = (if isBrowser then PulsarChannel else require './Channel')

client = (opt) ->
  out =
    options:
      namespace: 'Pulsar'
      resource: 'default'

    start: ->
      @channels = {}

    channel: (name) -> 
      @channels[name] ?= new Channel name, @ssocket

    inbound: (socket, msg, done) ->
      try
        done JSON.parse msg
      catch err
        @error socket, err

    outbound: (socket, msg, done) ->
      try
        done JSON.stringify msg
      catch err
        @error socket,  err

    validate: (socket, msg, done) ->
      return done false unless typeof msg is 'object'
      return done false unless typeof msg.type is 'string'
      if msg.type is 'emit'
        return done false unless typeof msg.channel is 'string'
        return done false unless typeof @channels[msg.channel]?
        return done false unless typeof msg.event is 'string'
        return done false unless Array.isArray msg.args
      else
        return done false
      return done true

    error: (socket, err) -> throw err
    close: (socket, reason) -> @emit 'close', reason
    message: (socket, msg) ->
      try
        chan = @channels[msg.channel]
        if msg.type is 'emit'
          chan.realEmit msg.event, msg.args...
      catch err
        @error socket, err

  out.options[k]=v for k,v of opt
  return out

if isBrowser
  window.Pulsar = createClient: (opt={}) -> ProtoSock.createClient client opt
else
  module.exports = client