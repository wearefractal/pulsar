Pulsar = require '../'
connect = require 'connect'

# Web Server
app = connect()
app.use connect.static __dirname
server = app.listen 8081

# Events
pulse = Pulsar.createServer({server:server});
auction = pulse.channel 'auction'

auction.on 'bid', (bid) ->
  auction.emit 'bid', bid

auction.on 'bidder', (bidder) ->
  auction.emit 'bidder', bidder

timeRemaining = 60
changeTime = ->
  timeRemaining--
  auction.emit 'timeRemaining', timeRemaining
  if timeRemaining isnt 0
    auction.emit 'endingSoon', true if timeRemaining < 50
    setTimeout changeTime, 1000
  else if timeRemaining is 0
    auction.emit 'endingSoon', false
    auction.emit 'ended', true

changeTime()