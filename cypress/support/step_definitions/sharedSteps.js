import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor'

Given('I visit the {string} page', (url) => {
    cy.visit(url)
  })

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
);