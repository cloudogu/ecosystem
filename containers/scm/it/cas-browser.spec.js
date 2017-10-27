const config = require('./config');
const expectations = require('./expectations');

const webdriver = require('selenium-webdriver');



const By = webdriver.By;
const until = webdriver.until;

jest.setTimeout(30000);

let driver;

beforeEach(() => {
    driver = new webdriver.Builder()
        .withCapabilities(webdriver.Capabilities.chrome())
        .build();
});

afterEach(() => {
    driver.quit();
});

function login() {
    driver.get(config.baseUrl + '/scm');
    driver.findElement(By.id('username')).sendKeys(config.username);
    driver.findElement(By.id('password')).sendKeys(config.password);
    driver.findElement(By.css('input[name="submit"]')).click();

    // waiting for finishing loading
    driver.wait(until.elementLocated(By.css('#scm-userinfo-tip')), 5000);
    const userInfoElement = driver.findElement(By.id('scm-userinfo-tip'));
    driver.wait(until.elementTextIs(userInfoElement, config.username), 5000);

}

describe('cas browser tests', () => {

    test('redirect to cas authentication', async() => {
        driver.get(config.baseUrl + '/scm');
        const url = await driver.getCurrentUrl();

        expectations.expectCasLogin(url);
    });

    test('cas authentication', async() => {
        login();

        const username = await driver.findElement(By.id('scm-userinfo-tip')).getText();
        expect(username).toBe(config.username);
    });

    test('check cas attributes', async() => { //in progress!
        login();
        driver.get(config.baseUrl + '/scm/api/rest/authentication/state.json');
        const bodyText = await driver.findElement(By.css('body')).getText();

        expectations.expectState(JSON.parse(bodyText));
    });

    test('front channel logout', async() => {
        login();
        driver.wait(until.elementLocated(By.css('#navLogout a'))).click();
        driver.wait(until.elementLocated(By.id('logout-message')));
        const url = await driver.getCurrentUrl();

        expectations.expectCasLogout(url);
    });

    test('back channel logout', async() => {
        login();
        driver.get(config.baseUrl + '/cas/logout');
        driver.get(config.baseUrl + '/scm');
        const url = await driver.getCurrentUrl();

        expectations.expectCasLogin(url);
    });

});