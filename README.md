# Implement Cucumber in Cypress 
## By **Mohammad Monfared** | [LinkedIn](https://www.linkedin.com/in/mohammad-monfared) | [YouTube](https://www.youtube.com/automationcamp) | [Website](http://www.monfared.io/)

---

## 0. Initial scenarios we're going to add as a spec file (we will have more later on)

```feature
Feature: Login functionalities
  Scenario: Verify valid login 
    Given I am in login page
    When I enter valid username and password
    And I click on login button
    Then I should logged in and redirected to dashboard page

  Scenario: Verify invalid login
    Given I am in login page
    When I enter invalid username and password
    And I click on login button
    Then I should see invalid credentials message

Feature: User filter functionalities
  Scenario: Verify filter users by username
    Given I am logged in
    And I am in admin page 
    When I put "admin" in user filter field
    Then the list should contain 1 record

  Scenario: Verify filter users by role
    Given I am logged in
    And I am in admin page
    When I select "admin" from role filter 
    Then the list should contain 6 record

```
## 1. Initialize node project and install cypress 

```
npm init -y
npm install cypress --save-dev
npx cypress open
```

## 2. Install packages

```javascript
npm install @badeball/cypress-cucumber-preprocessor --save-dev
npm install @bahmutov/cypress-esbuild-preprocessor --save-dev  // Bundle Cypress specs using esbuild - to increase performance
```
## 3. Update cypress configs

`cypress.config.js`

```javascript
const { defineConfig } = require("cypress");
const createBundler = require("@bahmutov/cypress-esbuild-preprocessor");
const preprocessor = require("@badeball/cypress-cucumber-preprocessor");
const createEsbuildPlugin = require("@badeball/cypress-cucumber-preprocessor/esbuild");

module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      on("file:preprocessor",
      createBundler({
        plugins: [createEsbuildPlugin.default(config)],
      }));
      preprocessor.addCucumberPreprocessorPlugin(on, config);
      return config;
    },
	specPattern: "**/*.feature",
  },
})

```

## 4. Update "cypress-cucumber-preprocessor" configs (Set step definitions path and make them global)
`package.json`

```javascript
"cypress-cucumber-preprocessor": {
    "step_definitions": "cypress/support/step_definitions/",
    "nonGlobalStepDefinitions": false
  }
```
## 5. Add IDE plugin for `.feature` files

This is one of the bests for VS-Code: [Cucumber (Gherkin) Full Support](https://marketplace.visualstudio.com/items?itemName=alexkrechik.cucumberautocomplete)

## 6 .Add feature files

`e2e/Login.feature`

```gherkin
Feature: Login features
  Scenario: Verify valid login 
    Given I am in login page
    When I enter valid username and password
    And I click on login button
    Then I should logged in and redirected to dashboard page
    
  Scenario: Verify invalid login
    Given I am in login page
    When I enter invalid username and password
	  And I click on login button
    Then I should see invalid credentials message
```

`e2e/Users.feature`

```gherkin
Feature: Users filter
  Scenario: Verify filter users by username
    Given I am logged in
    And I am in admin page 
    When I put "admin" in user filter field
    Then the list should contain 1 record

  Scenario: Verify filter users by role
    Given I am logged in
    And I am in admin page
    When I select "admin" from role filter 
    Then the list should contain 6 record
```

## 7. Add Step Definitions

`cypress/support/step_definitions/steps.js`

```javascript
import { Given, When, Then, DataTable } from '@badeball/cypress-cucumber-preprocessor'

Given('I am in login page', () => {
    cy.visit('https://opensource-demo.orangehrmlive.com')
  })

When ('I enter valid username and password', () => {
  cy.fixture('users.json').then((users) => {
    cy.get('input[name=username]').type(users.valid.username)
    cy.get('input[name=password]').type(users.valid.password)
  })
})

When ('I click on login button' , () => {
   cy.get('button[type=submit]').click()
})

Then('I should logged in and redirected to dashboard page', () => {
  cy.get('p.oxd-userdropdown-name').should('be.visible')
})

When ('I enter invalid username and password', () => {
  cy.fixtures('users.json').then((users) => {
    cy.get('input[name=username]').type(users.invalid.username)
    cy.get('input[name=password]').type(users.invalid.password)
  })
})

Then('I should see invalid credentials message', () => {
  cy.contains('Invalid credentials').should('be.visible')
})

```

## 8. How to pass value

```javascript
When('I enter {string} in username field',
    (username) => {
      cy.get('input[name=username]').type(username)
    }
  )
```
## 9. How to use regex in step definition title for combine multiple definitions

### Example 1

```javascript
Then(/the "(.*)" checkbox should be (enabled|disabled)/, (text, state) => {
    cy.get(`input[name=${text}]`).should(`be.${state}`)
})
```

```feature
Then the "Java" checkbox should be disabled
```
### Example 2

```javascript
Then(/the checkbox with id "(.*)" should be (selected|unselected)/, (id, condition) =>
  cy.get(`#${id}`).should(condition === 'selected' ? 'be.checked' : 'not.be.checked')
)
```
```feature
And the checkbox with id "check_python" should be unselected
```

### Example 3 

```javascript

// Given('I visit the {string} page', (url) => {
//     cy.visit(url)
// })

Then(/I should( not)? see the "(.*)" (radio button|toggle|checkbox)/,
  (condition, text) => {
    cy.get(`input[name=${text}]`).should(condition ? 'not.exist' : 'exist')
  }
)
```

```feature
And I should see the "german" toggle
Then I should not see "german" toggle
```

### Example 4

```javascript
When(/I scroll the table with locator "(.*)" (\d*) pixels (down|right)/,
  (locator, pixels, direction) => {
    const options = { duration: 250 };
    switch (direction) {
      case 'down':
        cy.get(locator).scrollTo('0px', `${pixels}px`, options);
        break;
      case 'right':
        cy.get(locator).scrollTo(`${pixels}px`, '0px', options);
    }
    cy.wait(500);
  }
)
```
```feature
Feature: Feature 1
  Scenario: Scenario 4
    Given I visit the "https://datatables.net/examples/basic_init/scroll_xy.html" page
    When I scroll the table with locator ".dataTables_scrollBody" 100 pixels right
    And I scroll the table with locator ".dataTables_scrollBody" 200 pixels down
```

## 10. How to do DataDrivenTesting

```javascript
Given('I am in playground page', () => {
    cy.visit('https://play1.automationcamp.ir/forms.html')
  })

When (/I check the "(.*)" (checkbox|toggle|radio button)/, (text) => {
  cy.get(`input[name=${text}]`).check()
})

Then(/the checkbox with id "(.*)" should be (selected|unselected)/, (id, condition) =>
  cy.get(`#${id}`).should(condition === 'selected' ? 'be.checked' : 'not.be.checked')
) 

Then(/the validate text with id "(.*)" should have text "(.*)"/, (id, text) => {
  cy.get(`#${id}`).should('have.text', text)
})
```

```feature
Feature: Feature 1

  Scenario Outline: Scenario 6
    Given I am in playground page 
    When I check the "<language>" checkbox
    Then the checkbox with id "<checkboxID>" should be <status>
    And the validate text with id "<textID>" should have text "<validateText>"
  Examples:
      | language | checkboxID | status | textID | validateText|
      | python | check_python | selected | check_validate | PYTHON |
      | javascript | check_javascript | selected | check_validate | JAVASCRIPT |
```
## 11. Steps with Data-tables

```javascript
When("I select multiple skills", (datatable) => {
  datatable.raw().forEach(item => {
    cy.get(`input[name=${item[0]}]`).check()
    cy.get(`#${item[1]}`).should('be.checked')
  })
})
```

```feature
Feature: Feature 1

  Scenario: Scenario 7 - Datatable
      Given I am in playground page
      When I select multiple skills
      | python| check_python | 
      | javascript | check_javascript |
      Then the validate text with id "check_validate" should have text "PYTHON JAVASCRIPT"
```
## 12. Background and Hooks

```javascript
Given("Make environment ready", () => {
  cy.log('Background hook - make env ready for use')
})
```

```feature
Feature: Add todo functionality
  Background: Test setup
    Given Make environment ready

  Scenario: Add multiple todos
  ...

```

```javascript
import { Given, When, Then, Before, After } from '@badeball/cypress-cucumber-preprocessor'

Before(() => {
  cy.log('Before each test')
})
After(() => {
  cy.log('After each test')
})
```

## 13. Tags

```gherkin

Feature: Login features

  @regression
  Scenario: Verify valid login 
    Given I am in login page
    When I enter valid username and password
    And I click on login button
    Then I should logged in and redirected to dashboard page
  
  @smoke
  Scenario: Verify invalid login
    Given I am in login page
    When I enter invalid username and password
	  And I click on login button
    Then I should see invalid credentials message
```
```
npx cypress run --env tags="@smoke"
npx cypress run --env tags="not @smoke"
npx cypress run --env tags="@smoke or @regression"
npx cypress run --env tags="@smoke and @regression"

```

## THANK YOU 🙂