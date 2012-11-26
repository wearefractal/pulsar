var nestObj = function(obj, keypath) {
    var ref = keypath.split('.');
    var last = ref.pop();
    for (var i = 0; i < ref.length; i++) {
      var k = ref[i];
      obj = obj[k];
    }
    return {result: obj, prop: last};
};
rivets.configure({
    adapter: {
      subscribe: function(obj, keypath, callback) {
        var res = nestObj(obj, keypath);
        window.auction.on(keypath, function(value){
          res.result[res.prop] = value;
          callback(value);
        });
      },
      read: function(obj, keypath) {
        var res = nestObj(obj, keypath);
        return res.result[res.prop];
      },
      publish: function(obj, keypath, value) {
        var res = nestObj(obj, keypath);
        res.result[res.prop] = value;
        window.auction.emit(res.prop, value);
      }
    }
});

rivets.configure({
  formatters: {
    currency: function(value){
      return accounting.formatMoney(value);
    },
    seconds: function(value){
      return value + " seconds";
    }
  }
});