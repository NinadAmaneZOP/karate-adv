function fn() {
  var env = karate.env; // environment name, e.g. 'perf' for local performance runs
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);

  var utils = karate.call('classpath:utils/js/utils.js');
  karate.set('utils', utils);
  var testData = karate.call('classpath:utils/js/test-data.js');
  var edgeData = karate.call('classpath:utils/js/edge-data.js');

  var config = {
    bookerBaseUrl: 'https://restful-booker.herokuapp.com',
    dummyBaseUrl: 'https://dummyjson.com',
    paths: {
      auth: '/auth',
      booking: '/booking',
      ping: '/ping',
      products: '/products'
    },
    headers: {
      json: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      acceptJson: { 'Accept': 'application/json' }
    },
    authCredentials: {
      admin: { username: 'admin', password: 'password123' },
      bad: { username: 'baduser', password: 'badpassword' }
    },
    utils: utils,
    testData: testData,
    edgeData: edgeData
  };

  if (env == 'perf') {
    // Safe local target for Gatling performance runs (started by the simulation).
    // This avoids sending load to public APIs by default.
    var perfPort = karate.properties['perf.port'] || '18081';
    config.bookerBaseUrl = 'http://localhost:' + perfPort;
    config.dummyBaseUrl = 'http://localhost:' + perfPort;
  }

  return config;
}
