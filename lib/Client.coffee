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

    error: (socket, err) -> throw err
    message: (socket, msg) ->
      chan = @channels[msg.channel]
      switch msg.type
        when 'emit'
          chan.realEmit msg.event, msg.args...
        when 'joined'
          chan.joined = true
          chan.realEmit 'join'

  out.options[k]=v for k,v of opt
  return out

if isBrowser
  window.Pulsar = createClient: (opt={}) -> ProtoSock.createClient client opt
  #define(->Pulsar) if typeof define is 'function'
else
  module.exports = client