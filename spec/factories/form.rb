Factory.define :form, :class => Noodall::Form do |form|
  form.title "A Form"
  form.email "hello@wearebeef.co.uk"

  form.fields do
    fields = [Factory(:text_field, :name => 'Name', :required => true), Factory(:text_field, :name => 'Email', :required => true)]
    5.times do
      fields << Factory(:text_field)
    end

    fields
  end
end
