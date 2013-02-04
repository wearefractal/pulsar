ProtoSock = require 'protosock'
client = require './Client'

module.exports =
  createClient: ProtoSock.createClientWrapper client
  createServer: ProtoSock.createServerWrapper server

if !window?
  server = require './Server'
  module.exports.createServer = ProtoSock.createServerWrapper server