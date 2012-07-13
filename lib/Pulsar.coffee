engine = require 'engine.io'
Channel = require './Channel'

class Pulsar
  constructor: (hook, @options={}, cb) ->
    @options.path ?= '/pulsar'
    if typeof hook is 'number'
      @server = engine.listen hook
    else
      @server = engine.attach hook, @options
      @server.httpServer = hook

    @server.on 'connection', @handleConnection
    @channels = {}

  close: =>
    @server.httpServer.close()
    return @

  drop: =>
    @server.close()
    return @

  channel: (name) => 
    @channels[name] ?= new Channel name

  handleConnection: (socket) => 
    socket.on 'message', (msg) => @handleMessage socket, msg

  handleMessage: (socket, msg) =>
    try
      {channel, event, args, action} = JSON.parse msg
    catch e
      return
    chan = @channels[channel]
    return unless chan?
    if action?
      return unless typeof action is 'string'
      chan.listeners.push socket if action is 'join'
      chan.realEmit 'newClient', socket
    else if event?
      args = [args] unless Array.isArray args
      chan.realEmit event, args...

Pulsar.Client = require '../client/Pulsar'
module.exports = Pulsar