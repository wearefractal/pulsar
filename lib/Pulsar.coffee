engine = require 'engine.io-f'
Channel = require './Channel'

class Pulsar
  constructor: (hook, @options={}, cb) ->
    @options.path ?= '/pulsar'
    if typeof hook is 'number'
      @server = engine.listen hook
    else
      @server = engine.attach hook, @options
      @server.httpServer = hook
    return

  close: =>
    @server.httpServer.close()
    return @

  drop: =>
    @server.close()
    return @

  channels: {}
  channel: (name) => @channels[name] ?= new Channel name, @server

Pulsar.Client = require '../client/Pulsar'
module.exports = Pulsar