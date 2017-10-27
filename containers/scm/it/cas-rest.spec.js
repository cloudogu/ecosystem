const request = require('supertest');
const config = require('./config');
const expectations = require('./expectations');

describe('cas rest tests', () =>  {

  test('authenticate with basic authentication', async() => {
    await request(config.baseUrl)
      .get('/scm/api/rest/repositories.json')
      .auth(config.username, config.password)
      .expect(200);
  });

  test('check cas attributes', async() => {
    const response = await request(config.baseUrl)
      .post('/scm/api/rest/authentication/login.json')
      .type('form')
      .send({
        username: config.username,
        password: config.password
      })
      .expect(200);

      expectations.expectState(response.body);
  });

});
