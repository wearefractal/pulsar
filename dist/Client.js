(function() {
  var Channel, client,
    __slice = Array.prototype.slice;

  Channel = require('./Channel');

  client = {
    options: {
      namespace: 'Pulsar',
      resource: 'default'
    },
    start: function() {
      var _this = this;
      this.channels = {};
      return this.on("reconnected", function() {
        var chan, name, _ref, _results;
        _ref = _this.channels;
        _results = [];
        for (name in _ref) {
          chan = _ref[name];
          _results.push(chan.joinChannel());
        }
        return _results;
      });
    },
    channel: function(name) {
      var _base, _ref;
      return (_ref = (_base = this.channels)[name]) != null ? _ref : _base[name] = new Channel(name, this.ssocket);
    },
    validate: function(socket, msg, done) {
      if (typeof msg !== 'object') return done(false);
      if (typeof msg.type !== 'string') return done(false);
      switch (msg.type) {
        case 'emit':
          if (typeof msg.channel !== 'string') return done(false);
          if (!typeof (this.channels[msg.channel] != null)) return done(false);
          if (typeof msg.event !== 'string') return done(false);
          if (!Array.isArray(msg.args)) return done(false);
          break;
        case 'joined':
          if (typeof msg.channel !== 'string') return done(false);
          if (!typeof (this.channels[msg.channel] != null)) return done(false);
          break;
        default:
          return done(false);
      }
      return done(true);
    },
    error: function(socket, err) {
      return this.emit('error', err, socket);
    },
    message: function(socket, msg) {
      var chan;
      chan = this.channels[msg.channel];
      switch (msg.type) {
        case 'emit':
          return chan.realEmit.apply(chan, [msg.event].concat(__slice.call(msg.args)));
        case 'joined':
          chan.joined = true;
          return chan.realEmit('join');
      }
    }
  };

  module.exports = client;

}).call(this);
