function fn() {
  var u = karate.get('utils');
  var firsts = ['James', 'Anna', 'Robert', 'Maria', 'David'];
  var lasts = ['Smith', 'Brown', 'Johnson', 'Miller'];
  var needs = ['Breakfast', 'Late Checkout', 'Crib'];

  function getDates() {
    var todayMs = new Date().getTime();
    var inMs = u.addDays(todayMs, u.randomNumber(1, 20));
    var outMs = u.addDays(inMs, u.randomNumber(1, 10));
    return { checkin: u.formatDate(inMs), checkout: u.formatDate(outMs) };
  }

  return {
    getDates: getDates,
    getBookingPayload: function(opts) {
      opts = opts || {};
      var payload = {
        firstname: opts.firstname !== undefined ? opts.firstname : (u.randomItem(firsts) + u.randomString(3)),
        lastname: opts.lastname !== undefined ? opts.lastname : (u.randomItem(lasts) + u.randomString(3)),
        totalprice: opts.totalprice !== undefined ? opts.totalprice : u.randomNumber(50, 500),
        depositpaid: opts.depositpaid !== undefined ? opts.depositpaid : true,
        bookingdates: opts.bookingdates !== undefined ? opts.bookingdates : getDates()
      };
      if (opts.includeNeeds !== false) {
        payload.additionalneeds = opts.additionalneeds !== undefined ? opts.additionalneeds : u.randomItem(needs);
      }
      return payload;
    },
    getPatchPayload: function() { return { additionalneeds: u.randomItem(needs) }; },
    getPartialPayload: function() { return { firstname: 'Patched' + u.randomString(3) }; },
    getEmptyFieldPayload: function() { return { firstname: '', lastname: u.randomItem(lasts), totalprice: 100, depositpaid: true, bookingdates: getDates() }; }
  };
}
