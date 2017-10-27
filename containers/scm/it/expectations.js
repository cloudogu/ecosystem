const config = require('./config');

exports.expectState = function(state) {
  const user = state.user;
  expect(user.type).toBe('cas');
  expect(user.name).toBe(config.username);
  expect(user.displayName).toBe(config.displayName);
  expect(user.mail).toBe(config.email);

  // TODO configure groups
  const groups = state.groups;
  expect(groups).toContain('cesManager');
  expect(groups).toContain('cesAdmins');
}

exports.expectCasLogin = function(url) {
  expect(url).toBe(config.baseUrl + '/cas/login?service=' + config.baseUrl + '/scm/');
}

exports.expectCasLogout = function(url) {
  expect(url).toBe(config.baseUrl + '/cas/logout');
}
