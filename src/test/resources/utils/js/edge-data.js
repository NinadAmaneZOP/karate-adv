function fn() {
  var u = karate.get('utils');
  function base() {
    return {
      firstname: 'Test' + u.randomString(3),
      lastname: 'User' + u.randomString(3),
      totalprice: 150,
      depositpaid: true,
      bookingdates: { checkin: '2026-12-01', checkout: '2026-12-10' }
    };
  }

  return {
    getMalformedPayload: function(field) {
      var p = base();
      delete p[field];
      return p;
    },
    getEdgePayload: function(fieldCase) {
      var p = base();
      if (fieldCase === 'empty_first') p.firstname = '';
      if (fieldCase === 'zero_price') p.totalprice = 0;
      if (fieldCase === 'negative_price') p.totalprice = -100;
      if (fieldCase === 'reverse_dates') p.bookingdates = { checkin: '2026-12-10', checkout: '2026-12-01' };
      if (fieldCase === 'extra_field') p.extraField = 'unexpectedValue';
      if (fieldCase === 'long_name') p.firstname = new Array(251).join('A');
      if (fieldCase === 'special_chars') p.firstname = '!@#$%^&*()_+';
      return p;
    }
  };
}
