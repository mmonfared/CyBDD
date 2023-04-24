Feature: Feature 1
    
    Background: Test setup
        Given I am in playground page 
    
    @regression 
    Scenario: Scenario 1
        # Given I am in playground page 
        Then the "java" checkbox should be disabled
        And the "python" checkbox should be enabled
    
    @smoke 
    Scenario: Scenario 2
        # Given I am in playground page 
        When I check the "python" checkbox
        Then the checkbox with id "check_python" should be selected
        Then the checkbox with id "check_javascript" should be unselected

    @regression @smoke 
    Scenario: Scenario 3
        # Given I am in playground page 
        Then I should see the "german" toggle
        And I should not see the "PHP" checkbox
    
    Scenario: Scenario 4
        Given I visit the "https://datatables.net/examples/basic_init/scroll_xy.html" page 
        When I scroll the table with locator ".dataTables_scrollBody" 100 pixels right
    
    Scenario: Scenario 5
        Given I visit the "https://datatables.net/examples/basic_init/scroll_xy.html" page 
        When I scroll the table with locator ".dataTables_scrollBody" 100 pixels down
    
    Scenario Outline: Scenario 6 - <language>
    # Given I am in playground page 
    When I check the "<language>" checkbox
    Then the checkbox with id "<checkboxID>" should be <status>
    And the validate text with id "<textID>" should have text "<validateText>"
    Examples:
      | language   | checkboxID       | status   | textID         | validateText|
      | python     | check_python     | selected | check_validate | PYTHON      |
      | javascript | check_javascript | selected | check_validate | JAVASCRIPT  |

    Scenario: Scenario 7 - DataTables
        # Given I am in playground page
        When I select multiple skills
        | python     | check_python | 
        | javascript | check_javascript |
        Then the validate text with id "check_validate" should have text "PYTHON JAVASCRIPT"
