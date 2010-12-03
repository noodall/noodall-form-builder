Factory.define :contact_form, :class => ContactForm do |component|
  component.form_id { Form.first.id }
end