(function() {
  var Channel,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = Array.prototype.slice;

  Channel = (function() {

    function Channel(name, socket) {
      this.name = name;
      this.socket = socket;
      this.runStack = __bind(this.runStack, this);
      this.use = __bind(this.use, this);
      this.ready = __bind(this.ready, this);
      this.removeAllListeners = __bind(this.removeAllListeners, this);
      this.removeListener = __bind(this.removeListener, this);
      this.once = __bind(this.once, this);
      this.addListener = __bind(this.addListener, this);
      this.emit = __bind(this.emit, this);
      this.realEmit = __bind(this.realEmit, this);
      this.events = {};
      this.stack = [];
      this.joinChannel();
    }

    Channel.prototype.joinChannel = function() {
      var _this = this;
      if (this.socket) {
        this.socket.write({
          type: 'join',
          channel: this.name
        });
        return this.socket.once("close", function() {
          return _this.joined = false;
        });
      } else {
        this.joined = true;
        return this.listeners = [];
      }
    };

    Channel.prototype.realEmit = function() {
      var args, event,
        _this = this;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.runStack(event, args, function(nargs) {
        var l, _i, _len, _ref;
        if (!_this.events[event]) return false;
        _ref = _this.events[event];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          l.apply(null, nargs);
        }
        return true;
      });
    };

    Channel.prototype.emit = function() {
      var args, event, msg, socket, _i, _len, _ref;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      msg = {
        type: 'emit',
        channel: this.name,
        event: event,
        args: args
      };
      if (this.listeners) {
        _ref = this.listeners;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          socket = _ref[_i];
          socket.write(msg);
        }
        return true;
      } else if (this.socket) {
        this.socket.write(msg);
        return true;
      } else {
        return false;
      }
    };

    Channel.prototype.addListener = function(event, listener) {
      var _base, _ref;
      this.realEmit('newListener', event, listener);
      ((_ref = (_base = this.events)[event]) != null ? _ref : _base[event] = []).push(listener);
      return this;
    };

    Channel.prototype.on = Channel.prototype.addListener;

    Channel.prototype.once = function(event, listener) {
      var fn,
        _this = this;
      fn = function() {
        _this.removeListener(event, fn);
        return listener.apply(null, arguments);
      };
      this.on(event, fn);
      return this;
    };

    Channel.prototype.removeSocketListener = function(listener) {
      var l;
      if (!this.listeners) return this;
      this.listeners = (function() {
        var _i, _len, _ref, _results;
        _ref = this.listeners;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          if (l !== listener) _results.push(l);
        }
        return _results;
      }).call(this);
      this.emit('unjoin', listener);
      this.realEmit('unjoin', listener);
      return this;
    };

    Channel.prototype.removeListener = function(event, listener) {
      var l;
      if (!this.events[event]) return this;
      this.events[event] = (function() {
        var _i, _len, _ref, _results;
        _ref = this.events[event];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          if (l !== listener) _results.push(l);
        }
        return _results;
      }).call(this);
      return this;
    };

    Channel.prototype.removeAllListeners = function(event) {
      delete this.events[event];
      return this;
    };

    Channel.prototype.ready = function(fn) {
      var _this = this;
      if (this.joined) {
        return fn(this);
      } else {
        return this.once('join', function() {
          return fn(_this);
        });
      }
    };

    Channel.prototype.use = function(fn) {
      this.stack.push(fn);
      return this;
    };

    Channel.prototype.runStack = function(event, args, cb) {
      var emit, idx,
        _this = this;
      if (this.stack.length === 0) return cb(args);
      if (event === 'newListener') return cb(args);
      idx = -1;
      emit = function() {
        var argv, next;
        argv = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (argv.length !== 0) args = argv;
        next = _this.stack[++idx];
        if (next == null) return cb(args);
        return next.apply(null, [emit, event].concat(__slice.call(args)));
      };
      emit.apply(null, args);
    };

    return Channel;

  })();

  module.exports = Channel;

}).call(this);
