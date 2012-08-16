Feature: Form builder response downloads
  In order to retrieve form responses for offline analysis
  As a website administrator
  I will be able to download form responses

  Scenario: Response CSV Download
    Given a form exists that has had many responses
    When I visit the form responses page and click download
    Then I should receive a CSV file containing all the responses to that form

  Scenario: Request an email when the download is ready
    Given a form exists that has had many responses
    And background queuing is turned on
    When I visit the form responses page and click download
    Then I should receive a CSV file containing all the responses to that form
    And I should recieve an email with a link to the download
