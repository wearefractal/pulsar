function anonymous(target, o, op) {
  if (!op) {
    op = "html";
  }
  return rivets.bind($(target)[op](function anonymous(locals, attrs, escape, rethrow, merge) {
    attrs = attrs || jade.attrs;
    escape = escape || jade.escape;
    rethrow = rethrow || jade.rethrow;
    merge = merge || jade.merge;
    var buf = [];
    with (locals || {}) {
      var interp;
      buf.push('<div id="auction"><h1 data-text="auction.title"></h1><img data-src="auction.image_url"/><br/><span data-text="auction.timeRemaining | seconds" data-hide="auction.ended"></span><p data-show="auction.endingSoon">Hurry up! This auction is ending soon.</p><p data-show="auction.ended">This auction is over.</p><dl><dt>Highest Bid:</dt><dd data-text="auction.bid | currency"></dd><dt>Bidder:</dt><dd data-text="auction.bidder"></dd></dl></div><div id="placebid"><h2>Change bid</h2><input type="text" data-value="auction.bidder" data-event-keyup="auction.svc"/><input type="text" data-value="auction.bid"/></div>');
    }
    return buf.join("");
  }(o))[0], o);
}