function anonymous(target, o, op) {
  if (!op) {
    op = "html";
  }
  return rivets.bind($(target)[op](function anonymous(locals, attrs, escape, rethrow, merge) {
    attrs = attrs || jade.attrs;
    escape = escape || jade.escape;
    rethrow = rethrow || jade.rethrow;
    merge = merge || jade.merge;
    var __jade = [ {
      lineno: 1,
      filename: "/home/contra/Projects/pulsar/example/in/login.jade"
    } ];
    try {
      var buf = [];
      with (locals || {}) {
        var interp;
        __jade.unshift({
          lineno: 1,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 1,
          filename: __jade[0].filename
        });
        buf.push('<div id="auction">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 2,
          filename: __jade[0].filename
        });
        buf.push('<h1 data-text="auction.title">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.shift();
        buf.push("</h1>");
        __jade.shift();
        __jade.unshift({
          lineno: 4,
          filename: __jade[0].filename
        });
        buf.push('<img data-src="auction.image_url"/>');
        __jade.shift();
        __jade.unshift({
          lineno: 5,
          filename: __jade[0].filename
        });
        buf.push("<br/>");
        __jade.shift();
        __jade.unshift({
          lineno: 5,
          filename: __jade[0].filename
        });
        buf.push('<span data-text="auction.timeRemaining | seconds" data-hide="auction.ended">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.shift();
        buf.push("</span>");
        __jade.shift();
        __jade.unshift({
          lineno: 6,
          filename: __jade[0].filename
        });
        buf.push('<p data-show="auction.endingSoon">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 6,
          filename: __jade[0].filename
        });
        buf.push("Hurry up! This auction is ending soon.");
        __jade.shift();
        __jade.shift();
        buf.push("</p>");
        __jade.shift();
        __jade.unshift({
          lineno: 7,
          filename: __jade[0].filename
        });
        buf.push('<p data-show="auction.ended">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 7,
          filename: __jade[0].filename
        });
        buf.push("This auction is over.");
        __jade.shift();
        __jade.shift();
        buf.push("</p>");
        __jade.shift();
        __jade.unshift({
          lineno: 9,
          filename: __jade[0].filename
        });
        buf.push("<dl>");
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 9,
          filename: __jade[0].filename
        });
        buf.push("<dt>");
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 9,
          filename: __jade[0].filename
        });
        buf.push("Highest Bid:");
        __jade.shift();
        __jade.shift();
        buf.push("</dt>");
        __jade.shift();
        __jade.unshift({
          lineno: 10,
          filename: __jade[0].filename
        });
        buf.push('<dd data-text="auction.bid | currency">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.shift();
        buf.push("</dd>");
        __jade.shift();
        __jade.unshift({
          lineno: 11,
          filename: __jade[0].filename
        });
        buf.push("<dt>");
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 11,
          filename: __jade[0].filename
        });
        buf.push("Bidder:");
        __jade.shift();
        __jade.shift();
        buf.push("</dt>");
        __jade.shift();
        __jade.unshift({
          lineno: 12,
          filename: __jade[0].filename
        });
        buf.push('<dd data-text="auction.bidder">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.shift();
        buf.push("</dd>");
        __jade.shift();
        __jade.shift();
        buf.push("</dl>");
        __jade.shift();
        __jade.shift();
        buf.push("</div>");
        __jade.shift();
        __jade.unshift({
          lineno: 13,
          filename: __jade[0].filename
        });
        buf.push('<div id="placebid">');
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 14,
          filename: __jade[0].filename
        });
        buf.push("<h2>");
        __jade.unshift({
          lineno: undefined,
          filename: __jade[0].filename
        });
        __jade.unshift({
          lineno: 14,
          filename: __jade[0].filename
        });
        buf.push("Change bid");
        __jade.shift();
        __jade.shift();
        buf.push("</h2>");
        __jade.shift();
        __jade.unshift({
          lineno: 16,
          filename: __jade[0].filename
        });
        buf.push('<input type="text" data-value="auction.bidder" data-event-keyup="auction.svc"/>');
        __jade.shift();
        __jade.unshift({
          lineno: 16,
          filename: __jade[0].filename
        });
        buf.push('<input type="text" data-value="auction.bid"/>');
        __jade.shift();
        __jade.shift();
        buf.push("</div>");
        __jade.shift();
        __jade.shift();
      }
      return buf.join("");
    } catch (err) {
      rethrow(err, __jade[0].filename, __jade[0].lineno);
    }
  }(o))[0], o);
}