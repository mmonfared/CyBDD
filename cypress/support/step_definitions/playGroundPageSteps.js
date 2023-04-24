import { Given, When, Then, Before, After } from '@badeball/cypress-cucumber-preprocessor'

Before(() => {
  cy.log('Test Setup')
})

After(() => {
  cy.log('Test Teardown')
})

Given('I am in playground page', () => {
    cy.visit('https://play1.automationcamp.ir/forms.html')
  })

Then(/the "(.*)" checkbox should be (enabled|disabled)/, (text, state) => {
    cy.get(`input[name=${text}]`).should(`be.${state}`)
})

When (/I check the "(.*)" (checkbox|toggle|radio button)/, (text) => {
  cy.get(`input[name=${text}]`).check()
})

Then(/the checkbox with id "(.*)" should be (selected|unselected)/, (id, condition) =>
  cy.get(`#${id}`).should(condition === 'selected' ? 'be.checked' : 'not.be.checked')
) 

Then(/I should( not)? see the "(.*)" (radio button|toggle|checkbox)/,
  (condition, text) => {
    cy.get(`input[name=${text}]`).should(condition ? 'not.exist' : 'exist')
  }
)

Then(/the validate text with id "(.*)" should have text "(.*)"/, (id, text) => {
  cy.get(`#${id}`).should('have.text', text)
})

When("I select multiple skills", (datatable) => {
  datatable.raw().forEach(item => { // datatable.raw() = [['python', 'check_python'], ['javadcript', 'check_javascript']]
    cy.log(item)
    cy.get(`input[name=${item[0]}]`).check()
    cy.get(`#${item[1]}`).should('be.checked')
  })
})