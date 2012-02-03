Factory.define :form, :class => Noodall::Form do |form|
  form.title "A Form"
  form.email "hello@wearebeef.co.uk"

  form.fields do
    fields = [Factory(:text_field, :name => 'Name', :required => true), Factory(:text_field, :name => 'Email', :required => true)]
    5.times do
      fields << Factory(:text_field)
    end
    fields << Factory(:check_box_field, :name => 'Check' )
    fields << Factory(:select_field, :name => 'Select')
    fields << Factory(:radio_field, :name => 'Radio')
    fields << Factory(:date_field, :name => 'Date', :required => true)

    fields
  end
end

Factory.define :blank_form, :class => Noodall::Form do |form|
  form.title "A Form"
  form.email "hello@wearebeef.co.uk"
end
