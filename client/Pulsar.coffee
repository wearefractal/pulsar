isBrowser = typeof window isnt 'undefined'
eio = require (if isBrowser then 'node_modules/engine.io-client/lib/engine.io-client' else 'engine.io-client')
Channel = require '../lib/Channel'

class Pulsar extends eio.EventEmitter
  constructor: (@options={}) ->
    if isBrowser
      @options.host ?= window.location.hostname
      @options.port ?= (if window.location.port.length > 0 then parseInt window.location.port else 80)
      @options.secure ?= (window.location.protocol is 'https:')

    @options.path ?= '/pulsar'
    @options.forceBust ?= true
    @options.debug ?= false

    @socket = new eio.Socket @options
    @socket.on 'open', @handleOpen
    @socket.on 'error', @handleError
    @socket.on 'message', @handleMessage
    @socket.on 'close', @handleClose
    @channels = {}
    @connected = false
    return

  channel: (name) => 
    @channels[name] ?= new Channel name, @socket

  disconnect: => 
    @socket.close()
    return

  connect: =>
    @socket.open()
    return

  # Event handlers
  handleError: (err) => throw err
  handleMessage: (msg) =>
    try
      {channel, event, args, action} = JSON.parse msg
    catch e
      @handleError err
      return
    chan = @channels[channel]
    return unless chan?
    args = [args] unless Array.isArray args
    chan.realEmit event, args...

  handleOpen: =>
    @connected = true
    @emit 'open'
    return

  handleClose: (args...) =>
    @connected = false
    @emit 'close', args...
    return

if typeof define is 'function'
  define -> Pulsar

window.Pulsar = Pulsar if isBrowser
module.exports = Pulsar
