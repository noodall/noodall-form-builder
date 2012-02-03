@website
Feature: Form Module
  In order to place the forms from the form builder on the website a website
  editor will be able to place a form within a template

  @javascript
  Scenario: Add Form
    Given forms have been created with the form builder
    And I am editing content
    When I click a "Wide" component slot
    And select the "Contact Form" component
    Then I should see a form select element containing the exisitng forms
    When I select a form
    And I press "Save" within the component
    And I press "Publish"
    When I visit the content page
    Then I should see the form I selected

  Scenario: Submit Form
    Given content exists with a form added via the contact module
    When a website visitor visits the content
    Then they should see the form
    When they fill in and submit the form
    Then the email address of the form should receive an email detailing the information submitted
    And they should receive an email confirming the request has been sent
    And the response should be stored in the database along with the time submitted, IP address, and page it was submitted from

  Scenario: Spam Filter
    Given content exists with a form added via the contact module
    When a form response is deemed to be spam
    Then it should marked as spam
    And they should receive no emails

    Given I am viewing the form's responses
    And I mark the response as not spam

    Then the email address of the form should receive an email detailing the information submitted
    And they should receive an email confirming the request has been sent

  #Scenario: Bad data is POSTed
    #Given content exists with a form added via the contact module
    #Then some random fields are POSTed by a spam bot
    #todo - better way to structure this feature?

  Scenario: Validation
    Given content exists with a form added via the contact module
    When a website visitor visits the content
    And they submit the form
    Then it should be checked against the validation speficied in the form builder
    And it should be rejected if the the response does not meet the validation
    And the website visitor should see an error message

  Scenario Outline: Validate Email Address
    Given content exists with a form added via the contact module
    When a website visitor visits the content
    And fill in "Email" with "<invalid email>"
    And they submit the form
    Then I should see "Email is invalid"

    Examples:
      | invalid email |
      | steve@moon |
      | spoon@buttonmooon.com dave@test.com |
      | spoon@buttonmooon.com; dave@test.com |


  Scenario: Custom Thank You Messages
    Given a form exists with the following:
      | thank_you_message | Thanks for that |
      | thank_you_email   | Cheers then!    |
    When I view the form on the website
    And I fill in the following:
      | Name | Dave |
      | Email | spoon@buttonmooon.com |
      | Date | 30/03/1976 |
    And I press "Send"
    Then I should see "Thanks for that"
    And "spoon@buttonmooon.com" should receive an email
    When I open the email
    Then I should see "Cheers then!" in the email body
