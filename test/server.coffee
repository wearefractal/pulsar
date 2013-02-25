http = require 'http'
should = require 'should'
Pulsar = require '../'
{join} = require 'path'

randomPort = -> Math.floor(Math.random() * 2000) + 8000

getServer = (port) ->
  port ||= randomPort()
  server = Pulsar.createServer http.createServer().listen port
  server.port = port
  server

getClient = (server) ->
  Pulsar.createClient
    host: server.server.httpServer.address().address
    port: server.server.httpServer.address().port
    resource: server.options.resource
    transports: ["websocket"]

describe 'Pulsar', ->
  describe 'channels', ->
    it 'should add', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      should.exist channel
      serv.destroy()
      done()

    it 'should emit join on server', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      should.exist channel

      client = getClient serv
      cchan = client.channel 'test'

      channel.on 'join', (socket) ->
        serv.destroy()
        client.destroy()
        done()

    it 'should emit join on client', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      should.exist channel

      client = getClient serv
      cchan = client.channel 'test'

      cchan.on 'join', ->
        serv.destroy()
        client.destroy()
        done()

    it 'should call ready on client', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      should.exist channel

      client = getClient serv
      cchan = client.channel 'test'
      cchan.ready ->
        serv.destroy()
        client.destroy()
        done()

    it 'should call', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      should.exist channel
      channel.on 'ping', (num) ->
        num.should.equal 2
        channel.emit 'pong', num

      client = getClient serv
      cchan = client.channel 'test'
      cchan.emit 'ping', 2
      cchan.on 'pong', (num) ->
        num.should.equal 2
        serv.destroy()
        client.destroy()
        done()

    it 'should call reverse', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      should.exist channel
      channel.on 'pong', (num) ->
        num.should.equal 2
        serv.destroy()
        client.destroy()
        done()

      client = getClient serv
      cchan = client.channel 'test'
      cchan.on 'ping', (num) ->
        num.should.equal 2
        cchan.emit 'pong', num

      channel.on 'join', (socket) ->
        channel.emit 'ping', 2

    it 'should join', (done) ->
      serv = getServer()
      channel = serv.channel 'test'

      client = getClient serv
      cchan = client.channel 'test'
      cchan.ready ->
        channel.listeners.length.should.equal 1
        channel.listeners[0].id.should.equal cchan.socket.id
        serv.destroy()
        client.destroy()
        done()

    it 'should unjoin on close', (done) ->
      serv = getServer()
      channel = serv.channel 'test'

      client = getClient serv
      cchan = client.channel 'test'
      cchan.ready ->
        channel.listeners.length.should.equal 1
        channel.listeners[0].id.should.equal cchan.socket.id
        channel.listeners[0].once 'close', ->
          channel.listeners.length.should.equal 0
          serv.destroy()
          done()
        client.destroy()

  describe 'multiple channels', ->
    it 'should add', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      channel2 = serv.channel 'test2'
      should.exist channel
      should.exist channel2
      serv.destroy()
      done()

    it 'should call', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      channel2 = serv.channel 'test2'
      should.exist channel
      should.exist channel2

      channel.on 'ping', (num) ->
        num.should.equal 2
        channel.emit 'pong', num

      channel2.on 'ping', (num) ->
        num.should.equal 3
        channel2.emit 'pong', num

      client = getClient serv
      cchan = client.channel 'test'
      cchan2 = client.channel 'test2'

      cchan.emit 'ping', 2
      cchan.on 'pong', (num) ->
        num.should.equal 2

        cchan2.emit 'ping', 3
        cchan2.on 'pong', (num) ->
          num.should.equal 3
          serv.destroy()
          client.destroy()
          done()

  describe 'multiple clients', ->
    it 'should broadcast to eachother', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      should.exist channel

      client = getClient serv
      client2 = getClient serv
      cchan = client.channel 'test'
      cchan2 = client2.channel 'test'

      cchan.ready ->
        cchan2.ready ->

          cchan2.on 'ping', (num) ->
            num.should.equal 2
            channel.emit 'pong', num

          cchan.on 'pong', (num) ->
            num.should.equal 2
            serv.destroy()
            client.destroy()
            done()

          cchan.emit 'ping', 2

  describe 'middleware', ->
    it 'should add', (done) ->
      serv = getServer()
      channel = serv.channel 'test'
      channel.use ->
      serv.destroy()
      done()

    it 'should call', (done) ->
      called = false
      serv = getServer()
      channel = serv.channel 'test'
      channel.use (emit, event, num) ->
        if event is 'ping'
          should.exist emit
          should.exist event
          should.exist num
          num.should.equal 2
          called = true
          emit()
      channel.on 'ping', (num) ->
        num.should.equal 2
        called.should.be.true
        serv.destroy()
        client.destroy()
        done()
      client = getClient serv
      cchan = client.channel 'test'
      cchan.emit 'ping', 2

    it 'should replace args', (done) ->
      called = false
      serv = getServer()
      channel = serv.channel 'test'
      channel.use (emit, event, num) ->
        if event is 'ping'
          should.exist emit
          should.exist event
          should.exist num
          num.should.equal 2
          called = true
          emit 3
      channel.on 'ping', (num) ->
        num.should.equal 3
        called.should.be.true
        serv.destroy()
        client.destroy()
        done()
      client = getClient serv
      cchan = client.channel 'test'
      cchan.emit 'ping', 2

  describe 'reconnect', ->
    #it 'should call on close and buffer messages', (done) ->
      #@timeout 5000
      #serv = getServer()
      #channel = serv.channel 'test'
      #channel2 = serv.channel 'test2'
      #should.exist channel
      #should.exist channel2

      #channel.on 'ping', (num) ->
        #num.should.equal 2
        #channel.emit 'pong', num

      #channel2.on 'ping', (num) ->
        #num.should.equal 3
        #channel2.emit 'pong', num

      #client = getClient serv
      #cchan = client.channel 'test'
      #cchan2 = client.channel 'test2'
      #client.once "connected", ->
        #cchan.ready ->
          #cchan2.ready ->
            #client.disconnect()

            #cchan.emit 'ping', 2
            #cchan.on 'pong', (num) ->
              #num.should.equal 2

              #cchan2.emit 'ping', 3
              #cchan2.on 'pong', (num) ->
                #num.should.equal 3
                #serv.destroy()
                #client.destroy()
                #done()

    it 'should reconnect channels', (done) ->
      serv = getServer()
      serv2 = null
      port = serv.port
      serv.channel 'test'

      client = getClient serv
      cchan = client.channel 'test'

      # tests should pass
      cchan.on 'pong', (num) ->
        num.should.equal 2
        client.destroy()
        serv2.destroy()
        done()

      # once the client is ready
      cchan.ready ->

        # disconnect the server
        serv.disconnect()
        serv.destroy()

        # create a new server
        serv2 = getServer port
        channel = serv2.channel 'test'

        # wire up server response
        channel.on 'ping', (num) ->
          num.should.equal 2
          channel.emit 'pong', num

        # trigger call/response
        client.on 'reconnected', ->
          cchan.emit 'ping', 2
