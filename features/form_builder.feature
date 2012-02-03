Feature: Form builder
  In order to capture data from website visitors a website editor will be able to create custom forms that can be placed on the website

  Scenario: Create a Form
    Given I visit the form builder admin page
    And I follow "New Form"
    Then I should see a form with at least the following fields:
      | Field       |
      | Name        |
      | Email       |
    When I fill the following fields:
      | Field             | Value                      |
      | Title             | A Contact Form             |
      | Description       | So people can get in touch |
      | Email             | hello@weaarebeef.co.uk     |
      | Thank you message | Cheers then!               |
      | Thank you email   | Thaanks for that           |
    And I add the fields I want on the form
    And I press "Create"
    Then I should see the new form in the Form List

  @javascript
  Scenario Outline: Add fields
    Given I am creating a form
    When I select "<Field Type>" from "Add a new field"
    And I click "Add"
    Then I should see a new field with the options "<Options>"

    Examples:
      | Field Type  | Options                                        |
      | Text        | Name, Label, Default, Rows, Required           |
      | Select      | Name, Label, Default Option, Options, Required |
      | Radio       | Name, Label, Default Option, Options, Required |
      | Check Box   | Name, Label, Default state, Required           |
      | Date        | Name, Label, Default, Required                 |

  @javascript
  Scenario: Reorder fields
    Given a form exists with the following fields:
      | Name    | Text Field            |
      | Email   | Text Field            |
      | Title   | Select Field: Mr, Mrs |
      | Message | Text Field            |
    When I am editing the form
    And I click the "up" arrow next to "Title" twice
    Then the "Title" field should be at position 1
    When I click the "down" arrow next to "Email" once
    Then the "Email" field should be at position 4
    When I press "Update"
    And I view the form on the website
    Then I should see the fields in the order I set

  Scenario: Response CSV Download
    Given a form exists that has had many responses
    When I visit the form builder admin page
    And I click "Download Responses" on the forms row in the Form List
    Then I should receive a CSV file containing all the responses to that form

  Scenario: Update an existing form with responses
    Given a form exists that has had many responses
    When I am editing the last form
    When I select "Text" from "Add a new field"
    And I click "Add"
    And I check "form_fields_3_required"
    And I press "Update"
    Then I should be on the form builder admin page
    And I should see "Form was successfully updated"

