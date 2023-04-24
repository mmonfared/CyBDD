Feature: Login features

  Scenario: Verify valid login 
    Given I am in login page
    # When I enter valid username and password
    When I enter "Admin" in username field
    And I enter "admin123" in password field
    # And I enter 123 in password field
    And I click on login button
    Then I should logged in and redirected to dashboard page
  
  Scenario: Verify invalid login
    Given I am in login page
    When I enter invalid username and password
	And I click on login button
    Then I should see invalid credentials message