When /^some random fields are POSTed by a spam bot$/ do
  lambda { 
    post noodall_form_form_responses_path(@_form), {:test => '123'}
  }.should raise_error(MongoMapper::DocumentNotFound, "Form response does not match form")
end
