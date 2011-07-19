When /^I visit the form builder admin page$/ do
  visit noodall_admin_forms_path
end

Then /^I should see a form with at least the following fields:$/ do |table|
  table.rows.each do |row|
    page.should have_selector("input[value='#{row[0]}']")
  end
end

When /^I fill the following fields:$/ do |table|
  table.hashes.each do |row|
    @new_form_name = row["Value"] if @new_form_name.nil?
    fill_in row["Field"], :with => row["Value"]
  end
end

When /^I add the fields I want on the form$/ do
# Some selenium dodads here

#  5.times do |i|
#    #get index of new fieldset
#    index = 1
#    response.should have_selector('#form-fields fieldset') do |fieldset|
#      index += 1
#    end
#    click_link_within 'div#main-form', 'Add'
#    save_and_open_page
#
#    within "fieldset#field-#{index}" do |fieldset|
#      fieldset.fill_in 'Name', :with => "Field #{i}"
#    end
#  end
end

Then /^I should see the new form in the Form List$/ do
  page.should have_content(@new_form_name)
end

Given /^I am creating a form$/ do
  visit new_noodall_admin_form_path
end

Then /^I should see a new field with the options "([^\"]*)"$/ do |arg1|
  #get index of new fieldset
  index = 0
  page.should have_selector('table.content tbody tr') do |fieldset|
    index += 1
  end

  page.should have_selector("input#form_fields_#{index}__type")
end

Given /^a form exists that has had many responses$/ do
  form = Factory(:form)
  9.times do
    Factory(:response, :form => form)
  end
end

When /^I click "([^\"]*)" on the forms row in the Form List$/ do |arg1|
  within('#content-table table tbody tr:first-child') do
    click_link arg1
  end
end

Then /^I should receive a CSV file containing all the responses to that form$/ do
  CSV.parse(page.source).should have(10).things # 9 rows plus header
end


Given /^forms have been created with the form builder$/ do
  5.times do
    Factory(:form)
  end
end

Then /^I should see a form select element containing the exisitng forms$/ do
  Noodall::Form.all.each do |form|
    page.should have_selector("select#node_wide_slot_0_form_id option:contains('#{form.title}')")
  end
end

When /^I select a form$/ do
  @_form = Noodall::Form.first
  select @_form.title, :from => 'Form'
end

Then /^I should see the form I selected$/ do
  @_form.fields.each do |field|
    case field.class
    when Noodall::TextField
      page.should have_selector("label[for=form_response_#{field.underscored_name}]")
    end
  end
end

Given /^a form exists$/ do
  Factory(:form)
end

Given /^content exists with a form added via the contact module$/ do
  @_node = Factory(:page_a)
  @_form = Factory(:form)
  @_node.wide_slot_0 = Factory(:contact_form, :form_id => @_form.id)
  @_node.save
end

When /^a website visitor visits the content$/ do
  visit node_path(@_node)
end

Then /^they should see the form$/ do
  Then %{I should see the form I selected}
end

When /^they fill in and submit the form$/ do
  @_form = Noodall::Form.find(@_node.wide_slot_0.form_id)
  @_form.fields.each do |field|
    if field.name == 'Email'
      fill_in "form_response[#{field.underscored_name}]", :with => 'hello@example.com'
    else
      if field.class == Noodall::TextField
        fill_in "form_response[#{field.underscored_name}]", :with => 'Weopunggggggggst'
      end
    end
  end

  When %{they submit the form}
end

Then /^the email address of the form should receive an email detailing the information submitted$/ do
  Then %{"#{@_form.email}" should receive an email}
  @_form.fields do |field|
    Then %{they should see "#{field.name}:" in the email body}
  end
end

Then /^they should receive an email confirming the request has been sent$/ do
  Then %{"hello@example.com" should receive an email}
  @_form.fields do |field|
    Then %{they should see "#{field.name}:" in the email body}
  end
end

Then /^the response should be stored in the database along with the time submitted, IP address, and page it was submitted from$/ do
  @_form.reload
  @response = @_form.responses.last

  @response.created_at.should_not be nil
  @response.ip.should == '127.0.0.1'
  @response.referrer.should == node_url(@_node)
end

Then /^it should be checked by a spam filter$/ do
  #err
end

Then /^it should be rejected if the spam filter deems the response to be spam$/ do
  within('form #errorExplanation') do
    page.should have_content('spam')
  end
end

Then /^the website visitor should see an spam message$/ do
  Then %{it should be rejected if the spam filter deems the response to be spam}
end

Then /^it should be checked against the validation speficied in the form builder$/ do
  @_form.required_fields.each do |field|
    within('#errorExplanation') do
      page.should have_content(field.name)
    end
  end
end

Then /^it should be rejected if the the response does not meet the validation$/ do
  Then %{it should be checked against the validation speficied in the form builder}
end

Then /^the website visitor should see an error message$/ do
    page.should have_selector('form #errorExplanation')
end

When /^a website visitor fills in and submits a form$/ do
  When %{they fill in and submit the form}
end

When /^they submit the form$/ do
  click_button 'Send'
end

When /^a form response is deemed to be spam$/ do
  When %{a website visitor visits the content}
  defensio_dummy = double("defensio dummy")
  defensio_dummy.stub(:post_document){ [200, {'spaminess' => 1, "allow" => false}] }
  defensio_dummy.stub(:put_document){ [200, {"allow" => false}] }

  Noodall::FormResponse.stub(:defensio).and_return(defensio_dummy)
  When %{they fill in and submit the form}
end

Then /^it should marked as spam$/ do
  Noodall::Form.last.responses.last.approved.should == false
end

When /^I click "([^"]*)"$/ do |arg1|
  click_link(arg1)
end

Given /^a form exists with the following fields:$/ do |table|
  fields = table.rows_hash.map do |name, type|
    factory, opts = type.split(': ')
    if opts.blank?
      Factory(factory.parameterize('_'), :name => name)
    else
      Factory(factory.parameterize('_'), :name => name, :options => opts)
    end
  end
  @_form = Factory(:form, :fields => fields)
end

When /^I am editing the form$/ do
  visit noodall_admin_form_path(@_form)
end

When /^I click the "([^\"]*)" arrow next to "([^\"]*)" twice$/ do |arrow, field|
  When %{I click the "#{arrow}" arrow next to "#{field}" once}
  When %{I click the "#{arrow}" arrow next to "#{field}" once}
end

Then /^the "([^"]*)" field should be at position (\d+)$/ do |field, position|
  index = 0
  all('table.content tbody tr').each do |fieldset|
    index = index+1
    break if fieldset.has_css?("input[value=#{field}]")
  end

  position.to_i.should == index
end

When /^I click the "([^\"]*)" arrow next to "([^\"]*)" once$/ do |arrow, field|
  all('table.content tbody tr').each do |fieldset|
    fieldset.find("a:contains('#{arrow}')").click if fieldset.has_css?("input[value=#{field}]")
  end
end

When /^I view the form on the website$/ do
  @_node = Factory(:page_a)
  @_node.wide_slot_0 = Factory(:contact_form, :form_id => @_form.id)
  @_node.save
  When %{a website visitor visits the content}
end

Then /^I should see the fields in the order I set$/ do
  within('div.form-wrap') do
    page.should have_content("Title")
  end
end

When /^I am editing the last form$/ do
  visit noodall_admin_form_path(Noodall::Form.last)
end

Given /^a form exists with the following:$/ do |fields|
  @_form = Factory(:form, fields.rows_hash)
end

Given /^I am viewing the form's responses$/ do
  visit noodall_admin_form_form_responses_path(@_form)
end

Given /^I mark the response as not spam$/ do
  When %{I follow "Not Spam?"} # This is tied to the current page, could be abstracted a little more
end


